const express = require('express');
const nodemailer = require('nodemailer');

const { Resend } = require('resend');
const resend = new Resend(process.env.RESEND_API_KEY);
const path = require('path');
const session = require('express-session');
const mysql = require('mysql2/promise'); // Note the '/promise'

const app = express();
const PORT = process.env.PORT || 3000;

// ============================================================
// DATABASE CONFIGURATION
// ============================================================
// We create a "pool" instead of a single connection. 
// A pool manages multiple connections automatically, making it crash-proof.
const db = mysql.createPool({
  host: process.env.MYSQLHOST || 'localhost',
  user: process.env.MYSQLUSER || 'root',  // Assuming your local MySQL user is root
  password: process.env.MYSQLPASSWORD || 'JayRakecha@2005',  // Assuming no password. Change if you set one on Linux Mint!
  database: process.env.MYSQLDATABASE || 'luxecasa',
  port: process.env.MYSQLPORT || 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  ssl: process.env.MYSQLHOST ? { rejectUnauthorized: false } : false
});
 


// Test the connection on startup
db.getConnection()
    .then(conn => {
        console.log('✅ Connected to MySQL Database successfully!');
        conn.release();
    })
    .catch(err => console.error('❌ Database connection failed:', err));

// ============================================================
// EXPRESS CONFIGURATION
// ============================================================
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use(session({
    secret: 'luxecasa-secret-key',
    resave: false,
    saveUninitialized: false
}));
app.use((req, res, next) => {
    if (req.path.endsWith('.html')) {
        const newUrl = req.url.replace('.html', '');
        return res.redirect(301, newUrl);
    }
    next();
});
const pageCssMap = {
    '/': 'index.css',
    '/about': 'about.css',
    '/checkout': 'checkout.css',
    '/contact': 'contact.css',
    '/faq': 'faq.css',
    '/login': 'login.css',
    '/offers': 'offers.css',
    '/product-detail': 'product-detail.css',
    '/products': 'products.css',
    '/profile': 'profile.css',
    '/refund': 'refund.css',
    '/terms': 'terms.css',
    '/wishlist': 'wishlist.css'
};

app.use((req, res, next) => {
    res.locals.pageCss = pageCssMap[req.path] || 'default.css';
    next();
});

// ============================================================
// DYNAMIC ROUTES (These require data from MySQL)
// ============================================================

// 1. Homepage Route
app.get('/', async (req, res) => {
    try {
        // Fetch only the curated system products for the homepage carousels
        const [rows] = await db.execute('SELECT * FROM catalog_products WHERE isSystemProduct = 1');
        res.render('index', { products: rows });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database Error');
    }
});
app.get('/index', (req, res) => res.redirect(301, '/'));

// 2. All Products Route
// GET — Products dikhao
app.get('/products', async (req, res) => {
    try {
        const [rows] = await db.execute('SELECT * FROM catalog_products');
        res.render('products', { products: rows });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database Error');
    }
});
// 3. Product Detail Route
// server.js - Product Detail Route
app.get('/product-detail', async (req, res) => {
    try {
        const productId = req.query.id || 1; // Default to 1 if missing
        
        // If they navigate here without an ID, send them back to products
        if (!productId) return res.redirect('/products');

        // Fetch the specific product
        const [rows] = await db.query('SELECT * FROM catalog_products WHERE id = ?', [productId]);

        // If product doesn't exist, handle it safely
        if (rows.length === 0) return res.status(404).send('Product not found');

        const mainProduct = rows[0];

        // Bonus feature: Fetch 4 related products from the same category
        const [relatedProducts] = await db.query(
            'SELECT * FROM catalog_products WHERE cat = ? AND id != ? LIMIT 4', 
            [mainProduct.cat, productId]
        );

        // Pass everything to the EJS file
        res.render('product-detail', { 
            product: mainProduct, 
            relatedProducts: relatedProducts 
        });

    } catch (err) {
        console.error("Error fetching product details:", err);
        res.status(500).send("Server Error");
    }
});

// ============================================================
// NEWSLETTER ROUTE (AJAX)
// ============================================================
app.post('/subscribe', async (req, res) => {
    try {
        const { email } = req.body;
        
        if (!email) {
            return res.json({ success: false, message: '⚠ Please provide an email address.' });
        }

        // Check for duplicates
        const [existing] = await db.execute('SELECT * FROM newsletter_subscribers WHERE email = ?', [email]);
        
        if (existing.length > 0) {
            // Email already exists
            return res.json({ success: false, message: 'ℹ You are already subscribed to our newsletter!' });
        }

        // Insert new subscriber
        await db.execute('INSERT INTO newsletter_subscribers (email) VALUES (?)', [email]);
        
        // Success
        res.json({ success: true, message: '🎉 Subscribed! Use code WELCOME10 at checkout for 10% off.' });
    } catch (err) {
        console.error('Newsletter Error:', err);
        res.status(500).json({ success: false, message: '⚠ Server error. Please try again later.' });
    }
});
// Submit Contact Form
app.post('/api/contact', async (req, res) => {
    const { name, email, message } = req.body;
    if (!name || !email || !message) {
        return res.status(400).json({ success: false, error: 'All fields are required' });
    }
    try {
        const query = 'INSERT INTO site_enquiries (name, email, message) VALUES (?, ?, ?)';
        await db.query(query, [name, email, message]);
        res.json({ success: true, message: 'Enquiry saved successfully' });
    } catch (error) {
        console.error('Contact Form Error:', error);
        res.status(500).json({ success: false, error: 'Database error' });
    }
});
// ============================================================
// AUTH MIDDLEWARE
// ============================================================
const requireLogin = (req, res, next) => {
    if (!req.session.userId) return res.redirect('/login');
    next();
};

const redirectIfLoggedIn = (req, res, next) => {
    if (req.session.userId) return res.redirect('/');
    next();
};
const multer = require('multer');
const fs = require('fs');

// Ensure the custom images directory exists
const uploadDir = path.join(__dirname, 'public', 'images', 'custom');
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

// Configure Multer to use Epoch timestamps for filenames
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, uploadDir);
    },
    filename: function (req, file, cb) {
        const ext = path.extname(file.originalname); // gets '.jpg' or '.png'
        const epoch = Date.now();
        cb(null, `${epoch}${ext}`);
    }
});
const upload = multer({ storage: storage });

// Admin Middleware Protection
const requireAdmin = (req, res, next) => {
    if (!req.session.isAdmin) return res.redirect('/login');
    next();
};
// ============================================================
// AUTHENTICATION API ROUTES (Plain Text for Viva)
// ============================================================

app.post('/api/auth/register', async (req, res) => {
    const { full_name, email, password } = req.body;
    try {
        // SECURITY CHECK: Block admin keywords
        if (email.toLowerCase().includes('admin') || full_name.toLowerCase().includes('admin')) {
            return res.json({ success: false, message: 'Reserved keyword used. Cannot register this account.' });
        }
        // 1. Check for duplicates
        const [existing] = await db.execute('SELECT id FROM active_users WHERE email = ?', [email]);
        if (existing.length > 0) {
            return res.json({ success: false, message: 'An account with this email already exists!' });
        }

        // 2. Insert PLAIN TEXT password directly into the database
        const [result] = await db.execute(
            'INSERT INTO active_users (name, email, password) VALUES (?, ?, ?)', 
            [full_name, email, password]
        );

        // 3. Save to session
        req.session.userId = result.insertId;
        req.session.userName = full_name;

        res.json({ success: true, user: { id: result.insertId, full_name, email } });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Server error during registration.' });
    }
});

app.post('/api/auth/login', async (req, res) => {
    const { email, password } = req.body;
    
    try {
        // 1. MASTER ADMIN CHECK
        if (email === 'admin@gmail.com' && password === 'admin') {
            req.session.userId = 'admin_1';
            req.session.userName = 'admin';
            req.session.isAdmin = true;
            return res.json({ success: true, isAdmin: true, message: 'Admin access granted.' });
        }

        // 2. Find normal user
        const [users] = await db.execute('SELECT * FROM active_users WHERE email = ?', [email]);
        if (users.length === 0) {
            return res.json({ success: false, message: 'Invalid email or password.' });
        }

        const user = users[0];

        // 3. Check PLAIN TEXT password
        if (password !== user.password) {
            return res.json({ success: false, message: 'Invalid email or password.' });
        }

        // 4. Save to session
        req.session.userId = user.id;
        req.session.userName = user.name;
        req.session.isAdmin = false;

        res.json({ success: true, isAdmin: false, user: { id: user.id, full_name: user.name, email: user.email } });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Server error during login.' });
    }
});

app.post('/api/auth/logout', (req, res) => {
    req.session.destroy();
    res.json({ success: true });
});

// Use middleware for page routes
app.get('/login', redirectIfLoggedIn, (req, res) => res.render('login'));

// ============================================================
// PROFILE ROUTE (Database Connected)
// ============================================================
app.get('/profile', requireLogin, async (req, res) => {
    try {
        // 1. Get User Data
        const [users] = await db.execute('SELECT id, name, email, created_at FROM active_users WHERE id = ?', [req.session.userId]);
        if (users.length === 0) {
            req.session.destroy();
            return res.redirect('/login');
        }
        const user = users[0];

        // 2. Get User's Orders
        const [orders] = await db.execute(
            'SELECT * FROM current_orders WHERE user_id = ? ORDER BY created_at DESC', 
            [user.id]
        );

        // 3. For each order, get the items inside it
        for (let order of orders) {
            const [items] = await db.execute(
                'SELECT * FROM curr_order_items WHERE order_id = ?', 
                [order.id]
            );
            order.items = items;
        }

        // 4. GET ALL PRODUCTS (For Live Wishlist Lookup)
        const [products] = await db.execute('SELECT id, name, price, oldPrice, productImage FROM catalog_products');

        // 5. Send all data to EJS
        res.render('profile', { user: user, orders: orders, products: products });
    } catch (err) {
        console.error(err);
        res.status(500).send("Database Error");
    }
});
// 1. Render the Offers Page
app.get('/offers', async (req, res) => {
    try {
        // Only fetch offers that have infinite uses OR haven't reached their limit yet
        const [offers] = await db.execute('SELECT * FROM offers WHERE max_uses IS NULL OR current_uses < max_uses');
        res.render('offers', { offers: offers });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database Error');
    }
});
// CHECKOUT API ROUTE
app.post('/api/checkout', async (req, res) => {
    const userId = req.session.userId;

    // 1. Check if session was wiped (e.g., Server Restart)
    if (!userId) {
        return res.status(401).json({ 
            success: false, 
            expired: true, 
            message: 'Session expired. Please log in again.' 
        });
    }

    const { cart, address, subtotal, discount, totalAmount, promoCode } = req.body;

    if (!cart || cart.length === 0) {
        return res.json({ success: false, message: 'Your cart is empty!' });
    }

    const connection = await db.getConnection();
    
    try {
        await connection.beginTransaction(); 

        // Insert main order
        const [orderResult] = await connection.execute(
            `INSERT INTO current_orders 
            (user_id, total_amount, discount_amount, final_amount, offer_code, shipping_address, payment_method, status) 
            VALUES (?, ?, ?, ?, ?, ?, 'COD', 'Pending')`,
            [userId, subtotal, discount, totalAmount, promoCode || null, address]
        );
        
        const orderId = orderResult.insertId;

        // Insert items
        for (let item of cart) {
            await connection.execute(
                `INSERT INTO curr_order_items 
                (order_id, product_id, product_name, price, quantity) 
                VALUES (?, ?, ?, ?, ?)`,
                [orderId, item.id, item.name, item.price, item.qty]
            );
        }
        
        // Update promo uses
        if (promoCode) {
            await connection.execute(
                'UPDATE offers SET current_uses = current_uses + 1 WHERE discount_code = ?', 
                [promoCode]
            );
        }
        
        await connection.commit();

// Email Notification
const cartItems = cart.map(item => 
    `${item.name} x${item.qty} - ₹${item.price}`
).join('\n');

resend.emails.send({
    from: 'onboarding@resend.dev',
    to: 'Jayrakecha12@gmail.com',
    subject: `🛍️ New Order #${orderId} - LuxeCasa`,
    text: `New order received!\n\nOrder ID: ${orderId}\nAddress: ${address}\nTotal: ₹${totalAmount}\n\nItems:\n${cartItems}`
}).then(data => console.log('✅ Order email sent!', data))
  .catch(err => console.error('Email error:', err));

res.json({ success: true, message: 'Order placed successfully!' });
    } catch (err) {
        await connection.rollback(); 
        console.error("Checkout Error DETAILS:", err);
        res.status(500).json({ success: false, message: 'SQL Error: ' + err.message });
    } finally {
        connection.release(); 
    }
});

// 2. API to Validate Promo Code on Checkout
app.post('/api/validate-promo', async (req, res) => {
    const { code } = req.body;
    try {
        const [offers] = await db.execute('SELECT * FROM offers WHERE discount_code = ?', [code]);
        
        if (offers.length === 0) {
            return res.json({ success: false, message: 'Invalid promo code.' });
        }
        
        const offer = offers[0];
        
        // Check usage limit
        if (offer.max_uses !== null && offer.current_uses >= offer.max_uses) {
            return res.json({ success: false, message: 'This promo code has reached its usage limit.' });
        }
        
        res.json({ 
            success: true, 
            discount_percent: offer.discount_percent, 
            code: offer.discount_code,
            message: `Success! ${offer.discount_percent}% off applied.`
        });
    } catch (err) {
        res.status(500).json({ success: false, message: 'Server error' });
    }
});
// ============================================================
// PROFILE UPDATE API
// ============================================================
app.post('/api/profile/update', requireLogin, async (req, res) => {
    try {
        const { firstName, lastName } = req.body;
        const fullName = (firstName + ' ' + lastName).trim();
        
        await db.execute(
            'UPDATE active_users SET name = ? WHERE id = ?',
            [fullName, req.session.userId]
        );
        
        // Update session name just in case
        req.session.userName = fullName;
        
        res.json({ success: true, message: 'Profile updated successfully!' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Database error' });
    }
});
// ============================================================
// ADMIN ROUTES & ENDPOINTS
// ============================================================
// ============================================================
// ADMIN ROUTES — LuxeCasa BCA Project
// Paste this block into server.js, replacing the old
// single-line: app.get('/admin', requireAdmin, (req, res) => res.render('admin'));
// ============================================================


// ──────────────────────────────────────────────────────────────
// GET /admin  ←  THE MAIN PAGE RENDER (with all DB data)
// Replaces the old empty render. Fetches every variable that
// admin.ejs needs: stats, users, orders, offers, enquiries,
// salesStats.
// ──────────────────────────────────────────────────────────────
app.get('/admin', requireAdmin, async (req, res) => {
    try {

        // ── 1. OVERVIEW STATS ────────────────────────────────
        const [[{ totalUsers }]]       = await db.execute('SELECT COUNT(*) AS totalUsers FROM active_users');
        const [[{ totalOrders }]]      = await db.execute('SELECT COUNT(*) AS totalOrders FROM current_orders');
        const [[{ pendingOrders }]]    = await db.execute("SELECT COUNT(*) AS pendingOrders FROM current_orders WHERE status = 'Pending'");
        const [[{ totalRevenue }]]     = await db.execute('SELECT COALESCE(SUM(final_amount), 0) AS totalRevenue FROM current_orders');
        const [[{ totalProducts }]]    = await db.execute('SELECT COUNT(*) AS totalProducts FROM catalog_products');
        const [[{ activeOffers }]]     = await db.execute('SELECT COUNT(*) AS activeOffers FROM offers WHERE max_uses IS NULL OR current_uses < max_uses');
        const [[{ totalEnquiries }]]   = await db.execute('SELECT COUNT(*) AS totalEnquiries FROM site_enquiries');
        const [[{ newsletterCount }]]  = await db.execute('SELECT COUNT(*) AS newsletterCount FROM newsletter_subscribers');

        const stats = {
            totalUsers,
            totalOrders,
            pendingOrders,
            totalRevenue,
            totalProducts,
            activeOffers,
            totalEnquiries,
            newsletterCount
        };

        // ── 2. USERS TABLE ───────────────────────────────────
        const [users] = await db.execute(
            'SELECT id, name, email, created_at FROM active_users ORDER BY created_at DESC'
        );

        // ── 3. ORDERS TABLE ──────────────────────────────────
        const [orders] = await db.execute(
            `SELECT id, user_id, total_amount, discount_amount, final_amount,
                    offer_code, payment_method, status, created_at
             FROM current_orders
             ORDER BY created_at DESC`
        );

        // ── 4. OFFERS TABLE ──────────────────────────────────
        const [offers] = await db.execute(
            'SELECT id, title, discount_code, discount_percent, current_uses, max_uses FROM offers ORDER BY id DESC'
        );

        // ── 5. ENQUIRIES TABLE ───────────────────────────────
        const [enquiries] = await db.execute(
            'SELECT id, name, email, message, created_at FROM site_enquiries ORDER BY created_at DESC'
        );

        // ── 6. SALES STATISTICS ──────────────────────────────

        // Total items sold (sum of all quantities across all order items)
        const [[{ totalItemsSold }]] = await db.execute(
            'SELECT COALESCE(SUM(quantity), 0) AS totalItemsSold FROM curr_order_items'
        );

        // Unique products that have ever been ordered
        const [[{ uniqueProducts }]] = await db.execute(
            'SELECT COUNT(DISTINCT product_id) AS uniqueProducts FROM curr_order_items'
        );

        // Gross revenue = sum of (price × quantity) per item, before order-level discounts
        const [[{ grossRevenue }]] = await db.execute(
            'SELECT COALESCE(SUM(price * quantity), 0) AS grossRevenue FROM curr_order_items'
        );

        // Net revenue = sum of final_amount on orders (after promo discounts)
        const [[{ netRevenue }]] = await db.execute(
            'SELECT COALESCE(SUM(final_amount), 0) AS netRevenue FROM current_orders'
        );

        // Product-wise breakdown: units sold + revenue per product
        const [productSales] = await db.execute(
            `SELECT
                oi.product_id,
                oi.product_name,
                cp.cat,
                SUM(oi.quantity)        AS total_qty,
                SUM(oi.price * oi.quantity) AS total_revenue
             FROM curr_order_items oi
             LEFT JOIN catalog_products cp ON cp.id = oi.product_id
             GROUP BY oi.product_id, oi.product_name, cp.cat
             ORDER BY total_qty DESC`
        );

        const salesStats = {
            totalItemsSold,
            uniqueProducts,
            grossRevenue,
            netRevenue,
            productSales
        };

        // ── 7. ALL PRODUCTS (for manage products table) ──────
        const [catalogProducts] = await db.execute(
            'SELECT id, name, cat, price, oldPrice, badge, productImage, isSystemProduct FROM catalog_products ORDER BY id DESC'
        );

        // ── RENDER ───────────────────────────────────────────
        res.render('admin', {
            stats,
            users,
            orders,
            offers,
            enquiries,
            salesStats,
            catalogProducts
        });

    } catch (err) {
        console.error('Admin render error:', err);
        res.status(500).send('Database Error');
    }
});


// ──────────────────────────────────────────────────────────────
// POST /api/admin/add-product
// Body: { name, cat, price, oldPrice, rating, reviews,
//         badge, description, productImage }
// Inserts a new row into catalog_products.
// ──────────────────────────────────────────────────────────────
app.post('/api/admin/add-product', requireAdmin, async (req, res) => {
    try {
        const {
            name, cat, price, oldPrice,
            rating, reviews, badge, description, productImage
        } = req.body;

        if (!name || !price) {
            return res.status(400).json({ success: false, message: 'Name and Price are required.' });
        }

        const [result] = await db.execute(
            `INSERT INTO catalog_products
                (name, cat, price, oldPrice, rating, reviews, badge, description, productImage, isSystemProduct)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0)`,
            [
                name,
                cat        || null,
                price,
                oldPrice   || null,
                rating     || 5,
                reviews    || 0,
                badge      || null,
                description || null,
                productImage || null
            ]
        );

        res.json({ success: true, id: result.insertId, message: 'Product added successfully!' });

    } catch (err) {
        console.error('Add product error:', err);
        res.status(500).json({ success: false, message: 'Database error: ' + err.message });
    }
});


// ──────────────────────────────────────────────────────────────
// POST /api/admin/add-offer
// Body: { title, discount_code, discount_percent, max_uses }
// max_uses = null means unlimited.
// ──────────────────────────────────────────────────────────────
app.post('/api/admin/add-offer', requireAdmin, async (req, res) => {
    try {
        const { title, discount_code, discount_percent, max_uses } = req.body;

        if (!title || !discount_code || !discount_percent) {
            return res.status(400).json({ success: false, message: 'Title, code and discount % are required.' });
        }

        // Prevent duplicate codes
        const [existing] = await db.execute(
            'SELECT id FROM offers WHERE discount_code = ?', [discount_code.toUpperCase()]
        );
        if (existing.length > 0) {
            return res.json({ success: false, message: 'This discount code already exists.' });
        }

        const [result] = await db.execute(
            `INSERT INTO offers (title, discount_code, discount_percent, max_uses, current_uses)
             VALUES (?, ?, ?, ?, 0)`,
            [
                title,
                discount_code.toUpperCase(),
                discount_percent,
                max_uses || null   // null = unlimited
            ]
        );

        res.json({ success: true, id: result.insertId, message: 'Offer created!' });

    } catch (err) {
        console.error('Add offer error:', err);
        res.status(500).json({ success: false, message: 'Database error: ' + err.message });
    }
});


// ──────────────────────────────────────────────────────────────
// DELETE /api/admin/delete-offer/:id
// Deletes an offer by its primary key.
// ──────────────────────────────────────────────────────────────
app.delete('/api/admin/delete-offer/:id', requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;

        const [result] = await db.execute('DELETE FROM offers WHERE id = ?', [id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: 'Offer not found.' });
        }

        res.json({ success: true, message: 'Offer deleted.' });

    } catch (err) {
        console.error('Delete offer error:', err);
        res.status(500).json({ success: false, message: 'Database error: ' + err.message });
    }
});


// ──────────────────────────────────────────────────────────────
// DELETE /api/admin/delete-enquiry/:id
// Deletes a customer enquiry by its primary key.
// ──────────────────────────────────────────────────────────────
app.delete('/api/admin/delete-enquiry/:id', requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;

        const [result] = await db.execute('DELETE FROM site_enquiries WHERE id = ?', [id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: 'Enquiry not found.' });
        }

        res.json({ success: true, message: 'Enquiry deleted.' });

    } catch (err) {
        console.error('Delete enquiry error:', err);
        res.status(500).json({ success: false, message: 'Database error: ' + err.message });
    }
});


// ──────────────────────────────────────────────────────────────
// DELETE /api/admin/delete-product/:id
// Deletes a product from catalog_products by its primary key.
// ──────────────────────────────────────────────────────────────
app.delete('/api/admin/delete-product/:id', requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;

        const [result] = await db.execute('DELETE FROM catalog_products WHERE id = ?', [id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: 'Product not found.' });
        }

        res.json({ success: true, message: 'Product deleted.' });

    } catch (err) {
        console.error('Delete product error:', err);
        res.status(500).json({ success: false, message: 'Database error: ' + err.message });
    }
});


// ──────────────────────────────────────────────────────────────
// POST /api/admin/upload  ← already in server.js, keep as-is
// POST /api/auth/logout   ← already in server.js, keep as-is
// ──────────────────────────────────────────────────────────────


// The Image Upload API
app.post('/api/admin/upload', requireAdmin, upload.single('productImage'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ success: false, message: 'No file uploaded.' });
    }
    // Return the path so the frontend can save it to the database
    const filePath = `/images/custom/${req.file.filename}`;
    res.json({ success: true, imageUrl: filePath });
});
// ============================================================
// STATIC ROUTES (No database needed, just render the page)
// ============================================================

app.get('/about', (req, res) => res.render('about'));
app.get('/checkout', (req, res) => res.render('checkout'));
app.get('/contact', (req, res) => res.render('contact'));
app.get('/faq', (req, res) => res.render('faq'));
app.get('/refund', (req, res) => res.render('refund'));
app.get('/terms', (req, res) => res.render('terms'));
app.get('/wishlist', (req, res) => res.render('wishlist'));

// Start Server
app.listen(PORT, () => {
    console.log(`LuxeCasa server is running at http://localhost:${PORT}`);
});
