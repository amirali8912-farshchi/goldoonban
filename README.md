# 🌱 Goldoonban

<p align="center">
  <img src="https://img.shields.io/badge/🌱_Goldoonban-Smart_Plant_System-1B5E20?style=for-the-badge" />
</p>

<p align="center">
  <b>سیستم هوشمند پایش و آبیاری گیاهان</b>
  <br>
  <sub>گیاهت رو تنها نذار؛ گلدون‌بان مراقبشه 🌿</sub>
</p>

<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">
  </a>
  <a href="https://dart.dev">
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white">
  </a>
  <a href="https://www.espressif.com/en/products/socs/esp32">
    <img src="https://img.shields.io/badge/ESP32-E7352C?style=for-the-badge&logo=espressif&logoColor=white">
  </a>
  <a href="https://micropython.org">
    <img src="https://img.shields.io/badge/MicroPython-2B2728?style=for-the-badge&logo=micropython&logoColor=white">
  </a>
  <a href="https://supabase.com">
    <img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white">
  </a>
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/amirali8912-farshchi/goldoonban?style=flat-square&logo=github">
  <img src="https://img.shields.io/github/forks/amirali8912-farshchi/goldoonban?style=flat-square&logo=github">
  <img src="https://img.shields.io/github/license/amirali8912-farshchi/goldoonban?style=flat-square">
</p>

---

## 🌿 درباره گلدون‌بان

**Goldoonban (گلدون‌بان)** یک پروژه IoT برای مراقبت هوشمند از گیاهان است.

ایده‌ی اصلی ساده است:

> **رطوبت خاک را اندازه بگیر → وضعیت گیاه را بررسی کن → در صورت نیاز آبیاری کن → همه‌چیز را از طریق موبایل مدیریت کن.**

در این پروژه یک **ESP32** به سنسور رطوبت خاک متصل می‌شود و اطلاعات مربوط به وضعیت خاک را دریافت می‌کند. سپس این اطلاعات از طریق اینترنت در **Supabase** ذخیره و مدیریت می‌شوند.

در طرف دیگر، یک اپلیکیشن **Flutter** قرار دارد که کاربر می‌تواند با استفاده از آن وضعیت گلدان را مشاهده کند، میزان رطوبت را بررسی کند و آبیاری را به‌صورت دستی یا خودکار کنترل کند.

به زبان ساده:

<p align="center">
  <b>🌱 گیاه</b>
  &nbsp;→&nbsp;
  <b>💧 سنسور</b>
  &nbsp;→&nbsp;
  <b>🔌 ESP32</b>
  &nbsp;→&nbsp;
  <b>☁️ Supabase</b>
  &nbsp;→&nbsp;
  <b>📱 اپلیکیشن</b>
</p>

---

# ✨ قابلیت‌های اصلی

<table>
<tr>
<td width="50%">

### 🌱 پایش گیاه

* 💧 اندازه‌گیری رطوبت خاک
* 📊 نمایش مقدار رطوبت
* 📈 مشاهده تغییرات رطوبت
* ⚙️ تنظیم محدوده مناسب رطوبت

</td>

<td width="50%">

### 💦 آبیاری هوشمند

* 🤖 آبیاری خودکار
* 🎛️ کنترل دستی پمپ
* 🔌 کنترل رله
* ⏱️ مدیریت زمان آبیاری

</td>
</tr>

<tr>
<td>

### 📱 اپلیکیشن

* 🏠 داشبورد وضعیت گلدان
* 📊 نمودار رطوبت
* 🎛️ کنترل آبیاری
* ⚙️ تنظیمات سیستم
* ☁️ نمایش وضعیت اتصال

</td>

<td>

### ☁️ ارتباط و داده

* 📡 ارتباط Wi-Fi
* ☁️ ذخیره اطلاعات در Supabase
* 🔄 ارسال و دریافت فرمان
* 📋 مدیریت اطلاعات سنسورها

</td>
</tr>
</table>

---

# 🏗️ معماری پروژه

<p align="center">

```text
                         🌱 GOLDOONBAN
                              │
                ┌─────────────┴─────────────┐
                │                           │
                ▼                           ▼
        🔌 ESP32 SYSTEM                📱 MOBILE APP
                │                           │
        ┌───────┴───────┐           ┌───────┴───────┐
        │               │           │               │
        ▼               ▼           ▼               ▼
   💧 Soil Sensor   💦 Water Pump  📊 Dashboard   🎛️ Control
        │               │           │               │
        └───────┬───────┘           └───────┬───────┘
                │                           │
                └─────────────┬─────────────┘
                              │
                              ▼
                         ☁️ SUPABASE
                              │
                              ▼
                         📡 INTERNET
```

</p>

---

# 📂 ساختار پروژه

```text
goldoonban/
│
├── 🔌 esp32/
│   │
│   ├── boot.py
│   ├── main.py
│   └── ...
│
├── 📱 mobile_app/
│   │
│   ├── lib/
│   ├── android/
│   ├── ios/
│   ├── pubspec.yaml
│   └── ...
│
├── 📄 LICENSE
└── 📖 README.md
```

---

# 🔌 بخش ESP32

<p align="center">
  <img src="https://img.shields.io/badge/ESP32-Hardware-E7352C?style=for-the-badge&logo=espressif&logoColor=white">
  <img src="https://img.shields.io/badge/MicroPython-Firmware-2B2728?style=for-the-badge&logo=micropython&logoColor=white">
  <img src="https://img.shields.io/badge/Wi--Fi-Connected-2196F3?style=for-the-badge&logo=wifi&logoColor=white">
</p>

### 🧠 مغز سخت‌افزاری پروژه

ESP32 مسئول کنترل قسمت سخت‌افزاری گلدون‌بان است.

این بخش اطلاعات سنسور رطوبت خاک را دریافت می‌کند و بر اساس تنظیمات سیستم تصمیم می‌گیرد که آیا گیاه به آب نیاز دارد یا خیر.

در صورت نیاز، ESP32 می‌تواند پمپ آب را از طریق رله فعال کند.

### 🔄 چرخه عملکرد

```text
        🌱 خاک
          │
          ▼
    💧 Soil Sensor
          │
          ▼
      🔌 ESP32
          │
     ┌────┴────┐
     │         │
     ▼         ▼
  رطوبت کم   رطوبت مناسب
     │         │
     ▼         ▼
 💦 Pump ON  Pump OFF
     │
     ▼
  💧 آبیاری
     │
     ▼
 رطوبت افزایش
     │
     ▼
 💦 Pump OFF
```

### 🧰 تجهیزات

| قطعه                    | وظیفه                 |
| ----------------------- | --------------------- |
| 🔌 ESP32                | کنترل اصلی سیستم      |
| 💧 Soil Moisture Sensor | اندازه‌گیری رطوبت خاک |
| 🔋 Power Supply         | تأمین انرژی           |
| ⚡ Relay Module          | کنترل پمپ             |
| 💦 Water Pump           | آبیاری گیاه           |

### 💻 Firmware

کد ESP32 با **MicroPython** نوشته شده است.

```text
esp32/
├── boot.py
├── main.py
└── ...
```

`boot.py` برای تنظیمات اولیه هنگام روشن شدن ESP32 استفاده می‌شود و `main.py` منطق اصلی سیستم را اجرا می‌کند.

---

# 📱 بخش Mobile App

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Mobile_App-02569B?style=for-the-badge&logo=flutter&logoColor=white">
  <img src="https://img.shields.io/badge/Dart-Programming_Language-0175C2?style=for-the-badge&logo=dart&logoColor=white">
</p>

### 📲 کنترل گلدون از داخل موبایل

اپلیکیشن گلدون‌بان با **Flutter** ساخته شده و رابط کاربری اصلی پروژه را در اختیار کاربر قرار می‌دهد.

کاربر می‌تواند بدون نیاز به دسترسی مستقیم به ESP32، وضعیت گلدان را مشاهده و سیستم آبیاری را کنترل کند.

### 🏠 بخش‌های اصلی اپلیکیشن

<table>
<tr>
<td align="center">🏠<br><b>Dashboard</b><br><sub>نمایش وضعیت گلدان</sub></td>
<td align="center">💧<br><b>Moisture</b><br><sub>رطوبت خاک</sub></td>
<td align="center">📈<br><b>Charts</b><br><sub>نمودار اطلاعات</sub></td>
<td align="center">💦<br><b>Watering</b><br><sub>کنترل آبیاری</sub></td>
<td align="center">⚙️<br><b>Settings</b><br><sub>تنظیمات</sub></td>
</tr>
</table>

### 📊 نمایش اطلاعات

اپلیکیشن اطلاعات دریافت‌شده از سیستم را به شکل قابل فهم نمایش می‌دهد؛ از جمله:

* 💧 میزان رطوبت فعلی
* 📈 تغییرات رطوبت در طول زمان
* 🤖 وضعیت آبیاری خودکار
* 💦 وضعیت پمپ
* ☁️ وضعیت اتصال به Supabase
* ⚙️ تنظیمات مربوط به آبیاری

---

# ☁️ Supabase

<p align="center">
  <img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white">
  <img src="https://img.shields.io/badge/PostgreSQL-Database-4169E1?style=for-the-badge&logo=postgresql&logoColor=white">
</p>

**Supabase** در این پروژه نقش Backend و پایگاه داده را بر عهده دارد.

اطلاعاتی که ESP32 دریافت می‌کند می‌تواند در Supabase ذخیره شود و اپلیکیشن Flutter نیز از همان اطلاعات برای نمایش وضعیت سیستم استفاده می‌کند.

همچنین فرمان‌های مربوط به کنترل سیستم می‌توانند از طریق همین بستر بین اپلیکیشن و ESP32 منتقل شوند.

```text
📱 Flutter
    │
    │ Read / Write
    ▼
☁️ Supabase
    │
    │ Internet
    ▼
🔌 ESP32
```

---

# 🚀 اجرای پروژه

## 📱 اجرای اپلیکیشن

ابتدا وارد پوشه اپلیکیشن شوید:

```bash
cd mobile_app
```

سپس وابستگی‌ها را دریافت کنید:

```bash
flutter pub get
```

و پروژه را اجرا کنید:

```bash
flutter run
```

برای ساخت APK:

```bash
flutter build apk
```

---

## 🔌 اجرای ESP32

کد موجود در پوشه:

```text
esp32/
```

را روی ESP32 قرار دهید.

قبل از اجرای سیستم، تنظیمات مربوط به موارد زیر را بررسی کنید:

```text
📡 Wi-Fi
☁️ Supabase
🔌 GPIO Pins
💧 Soil Sensor
💦 Water Pump
⚙️ Watering Settings
```

---

# 🔐 امنیت

اطلاعات حساس پروژه را مستقیماً در GitHub قرار ندهید.

مواردی مانند:

```text
🔑 Wi-Fi Password
🔐 Supabase Keys
🗄️ Database Credentials
```

باید در فایل‌های تنظیمات محلی یا روش‌های امن مدیریت Secret نگهداری شوند.

---

# 🗺️ Roadmap

```text
✅  Soil Moisture Monitoring
✅  ESP32 Control
✅  Water Pump Control
✅  Automatic Watering
✅  Manual Watering
✅  Flutter Application
✅  Supabase Integration
✅  Moisture Charts

🚧  Notification System
🚧  Multiple Plants
🚧  Advanced Analytics
🚧  Offline Mode
🚧  Power Consumption Optimization
🚧  Smart Irrigation Algorithm
```

---

# 🤝 مشارکت

اگر ایده‌ای برای بهتر شدن گلدون‌بان دارید، باگ پیدا کردید یا می‌خواهید قابلیت جدیدی اضافه کنید، می‌توانید از طریق **Issues** و **Pull Requests** در GitHub مشارکت کنید.

هر ایده‌ای که باعث شود گلدون‌بان **هوشمندتر، پایدارتر و کاربردی‌تر** شود، خوشحال‌کننده است. 🌱

---

# 📄 License

این پروژه تحت **MIT License** منتشر شده است.

برای اطلاعات کامل‌تر فایل [`LICENSE`](./LICENSE) را مشاهده کنید.

---

# 👨‍💻 Developer

<p align="center">

### Amirali Farshchi

<a href="https://github.com/amirali8912-farshchi">
  <img src="https://img.shields.io/badge/GitHub-amirali8912--farshchi-181717?style=for-the-badge&logo=github&logoColor=white">
</a>

</p>

---

<p align="center">
  🌱 <b>Goldoonban</b>
  <br>
  <sub>Smart plants. Smarter care.</sub>
  <br><br>
  <b>ساخته شده برای مراقبت هوشمندتر از گیاهان 🌿</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Made_with-❤️-E91E63?style=for-the-badge">
  <img src="https://img.shields.io/badge/Made_with-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">
  <img src="https://img.shields.io/badge/IoT-ESP32-E7352C?style=for-the-badge&logo=espressif&logoColor=white">
</p>
