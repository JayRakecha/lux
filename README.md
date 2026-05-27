# 🛋️ LuxeCase — Premium Readymade Furniture Store

> Your destination for luxury, comfort, and style — all under one roof.

---

## 🪑 About LuxeCase

**LuxeCase** is a full-stack e-commerce website built for premium readymade furniture. Whether you're looking for a stylish sofa, a comfortable bed, an elegant dining table, or the perfect chair — LuxeCase brings high-quality furniture straight to your home.

The website offers a seamless shopping experience with product browsing, wishlists, user profiles, checkout, and admin management — all in one place.

---

## ✨ Features

- 🏠 **Homepage** — Beautiful landing page showcasing featured and trending furniture
- 🛍️ **Products Page** — Browse the full furniture catalog with categories
- 🔍 **Product Detail** — Detailed view of each product with images and description
- 💖 **Wishlist** — Save your favourite items for later
- 🛒 **Checkout** — Smooth and secure order placement
- 🎁 **Offers Page** — Exclusive deals and discounts
- 👤 **User Profile** — Manage your account and order history
- 🔐 **Login / Register** — Secure user authentication with sessions
- 📞 **Contact Page** — Get in touch with the LuxeCase team
- ❓ **FAQ Page** — Answers to common questions
- 📄 **Terms & Refund Pages** — Transparent policies for customers
- 🛠️ **Admin Panel** — Manage products, orders, and users

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | Node.js, Express.js |
| **Templating** | EJS (Embedded JavaScript) |
| **Database** | MySQL (mysql2) |
| **Authentication** | express-session |
| **File Uploads** | Multer |
| **Email Service** | Nodemailer + Resend |
| **Environment** | dotenv |
| **Frontend** | HTML, CSS, JavaScript |

---

## 📂 Project Structure

```
luxecase/
├── server.js              # Main Express server
├── package.json           # Project dependencies
├── .env                   # Environment variables
├── public/
│   ├── css/               # Stylesheets for each page
│   ├── js/                # Frontend JavaScript
│   ├── image/             # Static product images
│   ├── images/            # Uploaded product images
│   └── webfonts/          # Font Awesome icons
├── views/
│   ├── index.ejs          # Homepage
│   ├── products.ejs       # Products listing
│   ├── product-detail.ejs # Single product view
│   ├── wishlist.ejs       # Wishlist page
│   ├── checkout.ejs       # Checkout page
│   ├── offers.ejs         # Offers & deals
│   ├── profile.ejs        # User profile
│   ├── login.ejs          # Login / Register
│   ├── admin.ejs          # Admin panel
│   ├── about.ejs          # About us
│   ├── contact.ejs        # Contact page
│   ├── faq.ejs            # FAQs
│   ├── terms.ejs          # Terms & Conditions
│   └── refund.ejs         # Refund policy
└── luxecasa_all.sql       # Database schema & seed data
```

---

## 🚀 Getting Started

### Prerequisites

- Node.js (v18+)
- MySQL database

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/luxecase.git

# 2. Navigate into the project
cd luxecase

# 3. Install dependencies
npm install

# 4. Set up your environment variables
cp .env.example .env
# Edit .env with your DB credentials and API keys

# 5. Import the database
mysql -u root -p < luxecasa_all.sql

# 6. Start the server
npm start
```

The website will run at **http://localhost:3000**

---

## ⚙️ Environment Variables

Create a `.env` file in the root with the following:

```env
PORT=3000
MYSQLHOST=localhost
MYSQLUSER=root
MYSQLPASSWORD=your_password
MYSQLDATABASE=luxecasa
MYSQLPORT=3306
RESEND_API_KEY=your_resend_api_key
```

---

## 📬 Contact

Have questions or feedback?

- 📧 Email: your@email.com
- 🌐 Website: [luxecase.com](https://luxecase.com)

---

<p align="center">Made with ❤️ by the LuxeCase Team</p>
