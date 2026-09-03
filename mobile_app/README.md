🌱 Goldoonban

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white">
  <img src="https://img.shields.io/badge/ESP32-E7352C?style=for-the-badge&logo=espressif&logoColor=white">
  <img src="https://img.shields.io/badge/MicroPython-2B2728?style=for-the-badge&logo=micropython&logoColor=white">
  <img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white">
</p><p align="center">
  <b>🌿 سیستم هوشمند پایش و آبیاری گیاهان</b>
</p><p align="center">
  <img src="https://img.shields.io/github/license/amirali8912-farshchi/goldoonban?style=flat-square">
  <img src="https://img.shields.io/github/stars/amirali8912-farshchi/goldoonban?style=flat-square">
  <img src="https://img.shields.io/github/forks/amirali8912-farshchi/goldoonban?style=flat-square">
</p>---

🌱 درباره پروژه

گلدون‌بان (Goldoonban) یک سیستم هوشمند برای پایش وضعیت گیاه و مدیریت آبیاری است.

این پروژه از یک ESP32 برای دریافت اطلاعات سنسور و کنترل تجهیزات و یک اپلیکیشن Flutter برای نمایش اطلاعات و کنترل سیستم استفاده می‌کند.

ارتباط و ذخیره‌سازی اطلاعات نیز با استفاده از Supabase انجام می‌شود.

---

✨ قابلیت‌ها

قابلیت| وضعیت
🌱 اندازه‌گیری رطوبت خاک| ✅
💧 کنترل پمپ آب| ✅
🤖 آبیاری خودکار| ✅
🎛️ کنترل دستی پمپ| ✅
📊 نمایش میزان رطوبت| ✅
📈 نمودار رطوبت| ✅
📱 اپلیکیشن موبایل| ✅
☁️ ارتباط با Supabase| ✅
🔄 ارتباط ESP32 با سرور| ✅
🔔 اعلان‌ها| 🚧
🌿 پشتیبانی از چند گلدان| 🚧

---

🏗️ ساختار پروژه

goldoonban/
│
├── 🌱 esp32/
│   └── کدهای مربوط به ESP32
│
├── 📱 mobile_app/
│   └── اپلیکیشن Flutter
│
├── 📄 LICENSE
└── 📖 README.md

---

🔌 سخت‌افزار

🧠 کنترلر

ESP32

🌡️ سنسورها

- 💧 سنسور رطوبت خاک

⚡ تجهیزات

- 🔌 ماژول رله
- 💦 پمپ آب DC
- 🔋 منبع تغذیه

---

📱 اپلیکیشن

اپلیکیشن موبایل با Flutter و Dart ساخته شده است.

امکانات اپلیکیشن

- 🏠 داشبورد وضعیت گلدان
- 💧 نمایش رطوبت خاک
- 📈 نمودار تغییرات رطوبت
- 🎛️ کنترل دستی آبیاری
- 🤖 فعال‌سازی آبیاری خودکار
- ⚙️ تنظیمات آبیاری
- ☁️ نمایش وضعیت ارتباط با Supabase

---

☁️ ارتباط سیستم

       🌱 Plant
          │
          ▼
   ┌─────────────┐
   │ Soil Sensor │
   └──────┬──────┘
          │
          ▼
      ┌───────┐
      │ ESP32 │
      └───┬───┘
          │
       Wi-Fi 📡
          │
          ▼
    ┌───────────┐
    │ Supabase  │
    └─────┬─────┘
          │
          ▼
    📱 Flutter App

---

🤖 آبیاری خودکار

در حالت اتوماتیک، ESP32 میزان رطوبت خاک را بررسی می‌کند.

💧 Read Moisture
       │
       ▼
  Moisture < Limit ?
     │          │
    YES         NO
     │          │
     ▼          ▼
 💦 Pump ON   Pump OFF
     │
     ▼
 Moisture ↑
     │
     ▼
 💦 Pump OFF

---

🛠️ تکنولوژی‌ها

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white">
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white">
  <img src="https://img.shields.io/badge/ESP32-E7352C?style=for-the-badge&logo=espressif&logoColor=white">
  <img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white">
  <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white">
</p>---

🚀 نصب و اجرا

📱 Flutter

cd mobile_app

flutter pub get

flutter run

برای ساخت APK:

flutter build apk

---

🌱 ESP32

کد مربوط به ESP32 در پوشه:

esp32/

قرار دارد.

قبل از اجرا، تنظیمات مربوط به موارد زیر را وارد کنید:

📡 Wi-Fi
☁️ Supabase
🔌 GPIO
💧 سنسور رطوبت
💦 پمپ

---

🔐 امنیت

⚠️ اطلاعات حساس را داخل GitHub قرار ندهید.

مواردی مثل:

Wi-Fi Password
Supabase API Key
Database Credentials

باید در فایل‌های تنظیمات محلی یا متغیرهای محیطی قرار بگیرند.

---

🗺️ Roadmap

- [x] 🌱 سنسور رطوبت
- [x] 💦 کنترل پمپ
- [x] 📱 اپلیکیشن Flutter
- [x] ☁️ اتصال Supabase
- [x] 📊 نمایش اطلاعات
- [ ] 🔔 سیستم اعلان
- [ ] 🌿 چند گلدان
- [ ] 📈 تحلیل پیشرفته داده‌ها
- [ ] 🔋 بهینه‌سازی مصرف انرژی
- [ ] 📡 عملکرد بهتر در زمان قطع اینترنت

---

🤝 مشارکت

اگر ایده‌ای برای بهتر شدن Goldoonban دارید یا باگی پیدا کردید، می‌توانید یک Issue ایجاد کنید یا Pull Request ارسال کنید.

---

📄 License

This project is licensed under the MIT License.

---

👨‍💻 Developer

Amirali Farshchi

<p align="center">
  <img src="https://img.shields.io/badge/Made%20with-❤️-red?style=for-the-badge">
  <img src="https://img.shields.io/badge/Made%20in-Iran-239E46?style=for-the-badge">
</p><p align="center">
  ⭐ اگر پروژه براتون مفید بود، خوشحال می‌شیم بهش Star بدید!
</p>