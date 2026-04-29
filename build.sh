#!/bin/bash

# تحميل Flutter SDK إذا لم يكن موجوداً
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

# إضافة مسار Flutter إلى متغيرات النظام
export PATH="$PATH:`pwd`/flutter/bin"

# تنظيف المشروع وجلب الحزم وبناء نسخة الويب
flutter clean
flutter pub get
flutter build web
