
// ============================================================
// GLOBAL STATE
// ============================================================
let cart = JSON.parse(localStorage.getItem('luxecasa_cart') || '[]');
let currentSlide = 0;
let slideInterval;
let trackOffset = 0;

// ============================================================
// HERO SLIDER
// ============================================================
const slides = document.querySelectorAll('.slide');
const dots = document.querySelectorAll('.slider-dot');

function goToSlide(n) {
    slides[currentSlide].classList.remove('active');
    dots[currentSlide].classList.remove('active');
    currentSlide = (n + slides.length) % slides.length;
    slides[currentSlide].classList.add('active');
    dots[currentSlide].classList.add('active');
    document.getElementById('slideCurrentNum').textContent = String(currentSlide + 1).padStart(2, '0');
}

function nextSlide() {
    goToSlide(currentSlide + 1);
    resetAutoSlide();
}

function prevSlide() {
    goToSlide(currentSlide - 1);
    resetAutoSlide();
}

function resetAutoSlide() {
    clearInterval(slideInterval);
    slideInterval = setInterval(nextSlide, 6000);
}

slideInterval = setInterval(nextSlide, 6000);

// Keyboard navigation
document.addEventListener('keydown', e => {
    if (e.key === 'ArrowRight') nextSlide();
    if (e.key === 'ArrowLeft') prevSlide();
});

// Touch swipe
let touchStartX = 0;
document.getElementById('heroSlider').addEventListener('touchstart', e => {
    touchStartX = e.changedTouches[0].screenX;
});
document.getElementById('heroSlider').addEventListener('touchend', e => {
    const diff = touchStartX - e.changedTouches[0].screenX;
    if (Math.abs(diff) > 50) {
        diff > 0 ? nextSlide() : prevSlide();
    }
});

// ============================================================
// SCROLL TRACK (Featured 4 Products)
// ============================================================
//function scrollTrack(dir) {
//    const track = document.getElementById('scrollTrack');
//    const cardWidth = document.getElementById('scroll-card1').offsetWidth;
//    const maxOffset = -(track.children.length - 1) * cardWidth;
//    trackOffset += dir * -cardWidth;
//    trackOffset = Math.min(0, Math.max(maxOffset, trackOffset));
//    track.style.transform = `translateX(${trackOffset}px)`;
//}
let currentOffset = 0;

function scrollTrack(dir) {
    const wrapper = document.querySelector(".scroll-track-wrapper");
    const track = document.getElementById("scrollTrack");
    const card = track.children[0];

    const cardWidth = card.offsetWidth;
    const maxOffset = Math.max(0, track.scrollWidth - wrapper.clientWidth) + 30;

    if (dir === 1) {
        if (currentOffset >= maxOffset) {
            currentOffset = 0;
        } else {
            currentOffset = Math.min(currentOffset + cardWidth, maxOffset);
        }
    } else if (dir === -1) {
        if (currentOffset <= 0) {
            currentOffset = maxOffset;
        } else {
            currentOffset = Math.max(currentOffset - cardWidth, 0);
        }
    }

    track.style.transform = `translateX(-${currentOffset}px)`;
}
// ============================================================
// PRODUCTS DATA
// ============================================================
const productsData = <% - JSON.stringify(products) %>;
/*const productsData = [
    { id: 1, name: 'Majestic Velvet Sofa', cat: 'sofas', price: 89999, oldPrice: 124999, rating: 5, reviews: 247, badge: 'sale', material: 'Velvet', desc: 'Premium midnight velvet upholstery with solid teak wood frame. Feather-soft cushioning.', img: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500&q=80' },
    { id: 2, name: 'Royal Emperor Bed', cat: 'beds', price: 124999, oldPrice: 179999, rating: 5, reviews: 389, badge: 'bestseller', material: 'Sheesham Wood', desc: 'Handcrafted from premium sheesham wood with upholstered headboard.', img: 'https://images.unsplash.com/photo-1505693314120-0d443867891c?w=500&q=80' },
    { id: 3, name: 'Marble Dining Table 8-Seater', cat: 'dining', price: 189999, oldPrice: 249999, rating: 4, reviews: 156, badge: 'new', material: 'Marble', desc: 'Italian Calacatta marble top with brushed stainless steel base.', img: 'https://images.unsplash.com/photo-1449247709967-d4461a6a6103?w=500&q=80' },
    { id: 4, name: 'Luxe Wingback Chair', cat: 'chairs', price: 44999, oldPrice: 62999, rating: 5, reviews: 203, badge: 'sale', material: 'Leather', desc: 'Mid-century modern design in caramel leather with solid brass legs.', img: 'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=500&q=80' },
    { id: 5, name: 'L-Shape Corner Sofa', cat: 'sofas', price: 129999, oldPrice: 179999, rating: 4, reviews: 178, badge: 'hot', material: 'Fabric', desc: 'Spacious L-shape sectional sofa perfect for large living rooms.', img: 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=500&q=80' },
    { id: 6, name: 'Moroccan Wardrobe', cat: 'wardrobes', price: 74999, oldPrice: 99999, rating: 5, reviews: 92, badge: 'bestseller', material: 'Mango Wood', desc: 'Intricately carved wardrobe with 4 mirrored sliding doors.', img: 'https://images.unsplash.com/photo-1558997519-83ea9252edf8?w=500&q=80' },
    { id: 7, name: 'High Gloss ceramic Cabinet', cat: 'cabinets', price: 54999, oldPrice: 74999, rating: 4, reviews: 67, badge: 'sale', material: 'Teak Wood', desc: 'Weather-resistant teak garden dining set. Perfect for patios.', img: 'https://images.unsplash.com/photo-1631048498692-af6262577031?w=600' },
    { id: 151, name: 'Floating Wall Cabinet 200cm', cat: 'cabinets', price: 44999, oldPrice: 61999, rating: 5, reviews: 234, badge: 'bestseller', material: 'MDF', desc: 'Premium walnut wood cabinet with elegant matte finish. Designed for modern homes with spacious compartments and smooth soft-close doors.', img: 'https://images.unsplash.com/photo-1631048835473-73c7aaf86096?w=600' },
    { id: 152, name: 'Solid Wood Cabinet', cat: 'cabinets', price: 34999, oldPrice: 47999, rating: 4, reviews: 189, badge: 'hot', material: 'Sheesham Wood', desc: ' Perfect for showcasing decor, crockery, or collectibles in a stylish and modern way.', img: 'https://plus.unsplash.com/premium_photo-1661963167025-ca61fd6b36d8?w=600' },
    { id: 153, name: '3-Drawer Wood Cabinet', cat: 'cabinets', price: 27999, oldPrice: 38999, rating: 4, reviews: 267, badge: 'new', material: 'Oak Wood', desc: 'Smart storage cabinet crafted for office use. Features lockable drawers, clean design, and durable engineered wood finish.', img: 'https://images.unsplash.com/photo-1701421047855-d7bafd8d6f69?w=600' },
];*/
// ============================================================
// PRODUCTS DATA (Loaded dynamically from MySQL via Node.js)
// ============================================================
function renderProducts(category = 'all') {
    const grid = document.getElementById('productsGrid');

    const filtered = category === 'all'
        ? productsData
        : productsData.filter(p => p.cat === category);

    const limited = filtered.slice(0, 8);

    grid.innerHTML = limited.map(p => {
        const badgeMap = {
            sale: '<span class="badge badge-sale">Sale</span>',
            new: '<span class="badge badge-new">New</span>',
            hot: '<span class="badge badge-hot">Hot</span>',
            bestseller: '<span class="badge badge-bestseller">Bestseller</span>'
        };

        const stars = '★'.repeat(p.rating) + '☆'.repeat(5 - p.rating);
        const discount = Math.round((1 - p.price / p.oldPrice) * 100);

        return `
        <div class="product-card" onclick="window.location.href='product-detail.html?id=${p.id}'">
            <div class="product-img-wrap">
                <img src="${p.productImage}" alt="${p.name}" loading="lazy">
                <div class="product-badges">${badgeMap[p.badge] || ''}</div>
                <div class="product-actions">
                    <button class="action-btn" onclick="event.stopPropagation(); toggleWishlist(${p.id}, this)" title="Wishlist"><i class="fas fa-heart"></i></button>
                    <button class="action-btn" onclick="event.stopPropagation(); window.location.href='product-detail.html?id=${p.id}'" title="Quick View"><i class="fas fa-eye"></i></button>
                    <button class="action-btn" onclick="event.stopPropagation(); addToCart(${p.id},'${p.name}',${p.price})" title="Add to Cart"><i class="fas fa-bag-shopping"></i></button>
                </div>
            </div>
            <div class="product-body">
                <p class="product-cat">${p.cat.replace('-', ' ')}</p>
                <h3 class="product-name">${p.name}</h3>
                <p class="product-short-desc">${p.description}</p>
                <div class="product-meta">
                    <div class="product-rating">
                        <span style="color:var(--gold)">${stars}</span>
                        <span style="font-size:0.75rem;color:var(--text-muted)">(${p.reviews})</span>
                    </div>
                    <span class="product-material">${p.material}</span>
                </div>
                <div class="product-footer">
                    <div class="product-price">
                        <span class="price-main">₹${p.price.toLocaleString('en-IN')}</span>
                        <span class="price-old">₹${p.oldPrice.toLocaleString('en-IN')}</span>
                        <span class="price-off">${discount}% OFF</span>
                    </div>
                    <button class="btn-cart" onclick="event.stopPropagation(); addToCart(${p.id},'${p.name}',${p.price})">
                        <i class="fas fa-bag-shopping"></i> Add
                    </button>
                </div>
            </div>
        </div>`;
    }).join('');

    setTimeout(() => {
        document.querySelectorAll('.product-card').forEach((el, i) => {
            setTimeout(() => el.classList.add('visible'), i * 80);
        });
    }, 100);
}
function filterProducts(cat, btn) {
    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    renderProducts(cat);
}

// ============================================================
// CART SYSTEM
// ============================================================
function addToCart(id, name, price) {
    const existing = cart.find(item => item.id === id);
    if (existing) {
        existing.qty++;
    } else {
        cart.push({ id, name, price, qty: 1, img: productsData.find(p => p.id === id)?.img || '' });
    }
    saveCart();
    updateCartUI();
    showToast(`✓ ${name} added to cart!`);
}

function removeFromCart(id) {
    cart = cart.filter(item => item.id !== id);
    saveCart();
    updateCartUI();
}

function changeQty(id, delta) {
    const item = cart.find(i => i.id === id);
    if (item) {
        item.qty += delta;
        if (item.qty <= 0) removeFromCart(id);
        else { saveCart(); updateCartUI(); }
    }
}

function saveCart() {
    localStorage.setItem('luxecasa_cart', JSON.stringify(cart));
}

function updateCartUI() {
    const total = cart.reduce((sum, i) => sum + i.qty, 0);
    const subtotal = cart.reduce((sum, i) => sum + i.price * i.qty, 0);
    const gst = Math.round(subtotal * 0.18);
    const grandTotal = subtotal + gst;

    document.getElementById('cartBadge').textContent = total;
    document.getElementById('cartCount').textContent = `(${total} item${total !== 1 ? 's' : ''})`;

    const listEl = document.getElementById('cartItemsList');
    const footerEl = document.getElementById('cartFooter');

    if (cart.length === 0) {
        listEl.innerHTML = `<div style="text-align:center;padding:60px 20px;color:var(--text-muted)">
            <i class="fas fa-shopping-bag" style="font-size:3rem;color:var(--cream2);margin-bottom:15px;display:block"></i>
            <p>Your cart is empty</p>
            <a href="products" style="color:var(--gold);font-size:0.85rem">Start Shopping →</a>
        </div>`;
        footerEl.style.display = 'none';
    } else {
        listEl.innerHTML = cart.map(item => `
        <div class="cart-item">
            <div class="cart-item-img">
                <img src="${item.img}" alt="${item.name}" onerror="this.src='https://via.placeholder.com/80x80?text=Furniture'">
            </div>
            <div class="cart-item-info">
                <h4 class="cart-item-name">${item.name}</h4>
                <p class="cart-item-price">₹${(item.price).toLocaleString('en-IN')}</p>
                <div class="cart-item-qty">
                    <button class="qty-btn" onclick="changeQty(${item.id}, -1)">−</button>
                    <span class="qty-num">${item.qty}</span>
                    <button class="qty-btn" onclick="changeQty(${item.id}, 1)">+</button>
                </div>
                <button class="cart-item-remove" onclick="removeFromCart(${item.id})">Remove</button>
            </div>
        </div>`).join('');

        document.getElementById('cartSubtotal').textContent = `₹${subtotal.toLocaleString('en-IN')}`;
        document.getElementById('cartGST').textContent = `₹${gst.toLocaleString('en-IN')}`;
        document.getElementById('cartTotal').textContent = `₹${grandTotal.toLocaleString('en-IN')}`;
        footerEl.style.display = 'block';
    }
}

function toggleCart() {
    document.getElementById('cartSidebar').classList.toggle('open');
    document.getElementById('cartOverlay').classList.toggle('show');
}

// ============================================================
// WISHLIST
// ============================================================
let wishlist = JSON.parse(localStorage.getItem('luxecasa_wishlist') || '[]');

function toggleWishlist(id, btn) {
    const idx = wishlist.indexOf(id);
    if (idx === -1) {
        wishlist.push(id);
        btn.classList.add('wishlist-active');
        showToast('❤ Added to wishlist');
    } else {
        wishlist.splice(idx, 1);
        btn.classList.remove('wishlist-active');
        showToast('Removed from wishlist');
    }
    localStorage.setItem('luxecasa_wishlist', JSON.stringify(wishlist));
}

function toggleWishlistCard(btn) {
    btn.classList.toggle('active');
    const isActive = btn.classList.contains('active');
    showToast(isActive ? '❤ Added to wishlist' : 'Removed from wishlist');
}

// ============================================================
// NAVBAR
// ============================================================
window.addEventListener('scroll', () => {
    const nav = document.getElementById('mainNav');
    const backTop = document.getElementById('backTop');
    if (window.scrollY > 80) {
        nav.classList.add('scrolled');
        backTop.classList.add('show');
    } else {
        nav.classList.remove('scrolled');
        backTop.classList.remove('show');
    }
});

function toggleSearch() {
    const q = prompt('Search for furniture...');
    if (q) window.location.href = `products?search=${encodeURIComponent(q)}`;
}

function toggleMobileMenu() {
    const links = document.querySelector('.nav-links');
    links.style.display = links.style.display === 'flex' ? 'none' : 'flex';
    links.style.flexDirection = 'column';
    links.style.position = 'absolute';
    links.style.top = '80px';
    links.style.left = '0';
    links.style.right = '0';
    links.style.background = '#fff';
    links.style.padding = '20px';
    links.style.boxShadow = '0 20px 40px rgba(0,0,0,0.1)';
    links.style.zIndex = '999';
}

// ============================================================
// JARALLAX PARALLAX ENGINE — vertical full-width panels
// ============================================================
(function initJarallaxEngine() {

    const panels = document.querySelectorAll('.jarallax-panel');
    if (!panels.length) return;

    /*
     * PARALLAX_SPEED: how many px the bg moves per px the user scrolls.
     * 0.30 = subtle premium feel. Increase to 0.50 for stronger depth.
     */
    const PARALLAX_SPEED = 0.45;

    function updateParallax() {
        const winH = window.innerHeight;

        panels.forEach(panel => {
            const img = panel.querySelector('.jara-img');
            const prog = panel.querySelector('.jara-progress');
            if (!img) return;

            const rect = panel.getBoundingClientRect();

            // Skip panels fully outside the viewport (perf optimisation)
            if (rect.bottom < -200 || rect.top > winH + 200) return;

            /*
             * panelProgress: 0 when panel bottom just enters viewport bottom,
             *                1 when panel top just exits viewport top.
             * Used to drive both parallax offset and the side progress bar.
             */
            const panelProgress = 1 - (rect.bottom / (winH + rect.height));
            const clampedProgress = Math.max(0, Math.min(1, panelProgress));

            /*
             * translateY offset:
             *   - When panel is below viewport: img is shifted DOWN  (+)
             *   - When panel is above viewport: img is shifted UP    (-)
             * The image is 140% tall so there is room to move 40% / 2 = 20%
             * in each direction without ever showing a gap.
             */
            const panelH = rect.height;
            const maxOffset = panelH * 0.20;                    // 20% of panel height
            const centreRel = rect.top + panelH / 2 - winH / 2; // px from viewport centre
            const offset = centreRel * PARALLAX_SPEED;
            const clamped = Math.max(-maxOffset, Math.min(maxOffset, offset));

            // Apply — keep hover scale if present, just change translateY
            const isHovered = panel.matches(':hover');
            const scale = isHovered ? 1.06 : 1.0;
            img.style.transform = `translateY(${clamped}px) scale(${scale})`;

            // Side progress bar
            if (prog) {
                prog.style.height = (clampedProgress * 100).toFixed(1) + '%';
            }
        });
    }

    // Preserve hover scale alongside parallax translateY
    panels.forEach(panel => {
        const img = panel.querySelector('.jara-img');
        if (!img) return;
        panel.addEventListener('mouseenter', updateParallax, { passive: true });
        panel.addEventListener('mouseleave', updateParallax, { passive: true });
    });

    let rafId;
    function onScroll() {
        if (rafId) cancelAnimationFrame(rafId);
        rafId = requestAnimationFrame(updateParallax);
    }

    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', updateParallax, { passive: true });

    // Initial paint
    updateParallax();
})();


const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('visible');
        }
    });
}, { threshold: 0.1 });

document.querySelectorAll('.reveal, .reveal-left, .reveal-right').forEach(el => observer.observe(el));

// ============================================================
// COUNTDOWN TIMER
// ============================================================
function updateCountdown() {
    const endDate = new Date();
    endDate.setDate(endDate.getDate() + 12);
    endDate.setHours(8, 45, 30);

    function tick() {
        const now = new Date();
        const diff = endDate - now;
        if (diff <= 0) return;

        const d = Math.floor(diff / 86400000);
        const h = Math.floor((diff % 86400000) / 3600000);
        const m = Math.floor((diff % 3600000) / 60000);
        const s = Math.floor((diff % 60000) / 1000);

        const fmt = n => String(n).padStart(2, '0');
        document.getElementById('cdDays').textContent = fmt(d);
        document.getElementById('cdHours').textContent = fmt(h);
        document.getElementById('cdMins').textContent = fmt(m);
        document.getElementById('cdSecs').textContent = fmt(s);
    }

    tick();
    setInterval(tick, 1000);
}

updateCountdown();

// NEWSLETTER (Database Connected)
async function subscribeNewsletter(e) {
    e.preventDefault(); // Stop page from reloading

    const emailInput = document.getElementById('newsletterEmail');
    const email = emailInput.value.trim();

    try {
        // Send data to our Node.js server
        const response = await fetch('/subscribe', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: email })
        });

        const data = await response.json();

        // Show the result in the Toast popup
        showToast(data.message);

        // Clear the input only if it was successful
        if (data.success) {
            emailInput.value = '';
        }
    } catch (err) {
        showToast('⚠ Error connecting to server.');
    }
}
// ============================================================
// TOAST NOTIFICATION
// ============================================================
let toastTimeout;
function showToast(msg) {
    const toast = document.getElementById('toast');
    toast.innerHTML = msg;
    toast.classList.add('show');
    clearTimeout(toastTimeout);
    toastTimeout = setTimeout(() => toast.classList.remove('show'), 3000);
}

// ============================================================
// USER SESSION CHECK
// ============================================================
function checkSession() {
    const user = JSON.parse(localStorage.getItem('luxecasa_user'));
    const btn = document.getElementById('navLoginBtn');
    if (user && btn) {
        btn.innerHTML = `<i class="fas fa-user-circle"></i> ${user.full_name}`;
        btn.href = 'profile.html';
    }
}

// ============================================================
// INIT
// ============================================================
renderProducts();
updateCartUI();
checkSession();