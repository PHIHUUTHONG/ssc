#!/system/bin/sh
#! Telegram: @TorryTran
##############################################################################
# Các biến cần thiết 
FOLDER_TOOLS="/data/local/apktool/"
APK_UNPACK="/storage/emulated/0/ToolsVH/apk_unpack/"
APK_IMPORT="/storage/emulated/0/ToolsVH/apk_import/"
APK_REPACK="/storage/emulated/0/ToolsVH/apk_repack/"
LINK_DOWNLOAD="$FOLDER_TOOLS/MIUI-14-XML-Vietnamese-master/Vietnamese/main/"
ALL_STRINGS="$APK_UNPACK*/res/values-vi/strings.xml"
ALL_DATE=$(date +%d.%m.%Y)
DATE="${ALL_DATE}"

# Hàm này xuất ra đầu màn hình tên của nhà phát triển 
ECHO_FRAME() { clear
TEXT="ToolsVH 55 app overlay by TorryTran | Ver: 2.0"
LENGTH=${#TEXT}
FRAME="#"
echo "\033[1;32m$FRAME$(printf '%*s' $LENGTH | tr ' ' "$FRAME")$FRAME$FRAME$FRAME"
echo "$FRAME $TEXT $FRAME"
echo "$FRAME$(printf '%*s' $LENGTH | tr ' ' "$FRAME")$FRAME$FRAME$FRAME\e[0m"
echo; }

# Chữ màu
ECHO_TEXT_RED() { echo -n "\e[31m$1\e[0m"; } # Đỏ
ECHO_TEXT_GREEN_1() { echo -n "\e[32m$1\e[0m"; } # Xanh lá
ECHO_TEXT_GREEN_2() { echo -n "\e[36m$1\e[0m"; } # Xanh lục
ECHO_TEXT_GOLD() { echo -n "\e[33m$1\e[0m"; } # Vàng
ECHO_TEXT_BLUE() { echo -n "\e[34m$1\e[0m"; } # Xanh dương 
ECHO_TEXT_PURPLE() { echo -n "\e[35m$1\e[0m"; } # Tím
ECHO_TEXT_WHITE() { echo -n "\e[37m$1\e[0m"; } # Trắng

# Nền màu
ECHO_BACKGROUND_RED() { echo -n "\e[41m$1\e[0m"; } # Đỏ
ECHO_BACKGROUND_GREEN_1() { echo -n "\e[42m$1\e[0m"; } # Xanh lá
ECHO_BACKGROUND_GREEN_2() { echo -n "\e[46m$1\e[0m"; } # Xanh lục
ECHO_BACKGROUND_GOLD() { echo -n "\e[43m$1\e[0m"; } # Vàng
ECHO_BACKGROUND_BLUE() { echo -n "\e[44m$1\e[0m"; } # Xanh dương 
ECHO_BACKGROUND_PURPLE() { echo -n "\e[45m$1\e[0m"; } # Tím
ECHO_BACKGROUND_WHITE() { echo -n "\e[47m$1\e[0m"; } # Trắng

# Hàm này viết ra ứng dụng overlay 
BUILD_APK() {
APK="$1"
mkdir -p "$APK_UNPACK$APK/original/META-INF"
mkdir -p "$APK_UNPACK$APK/res/values"
mkdir -p "$APK_UNPACK$APK/res/values-vi"
touch "$APK_UNPACK$APK/apktool.yml"
touch "$APK_UNPACK$APK/original/META-INF/CERT.RSA"
touch "$APK_UNPACK$APK/original/META-INF/CERT.SF"
touch "$APK_UNPACK$APK/original/META-INF/MANIFEST.MF"
touch "$APK_UNPACK$APK/res/values-vi/strings.xml"
echo '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n</resources>' > $APK_UNPACK$APK/res/values-vi/strings.xml
AndroidManifest="$APK_UNPACK/$APK/AndroidManifest.xml"
ApktoolJson="$APK_UNPACK$APK/apktool.yml"
SOverlay="$3overlay."
Overlay="$DEV_OVERLAY_NAME$SOverlay$2"
Code1='<?xml version="1.0" encoding="utf-8"?>\n<manifest\n    android:compileSdkVersion='\"$API\"'\n    android:compileSdkVersionCodename='\"$DATE$ADR\"'\n    package='\"$Overlay\"'\n    platformBuildVersionCode='\"$API\"'\n    platformBuildVersionName='\"$DATE$ADR\"'\n    xmlns:android="http://schemas.android.com/apk/res/android">\n    <overlay\n        android:priority="1"\n        android:targetPackage='\"$2\"'\n        android:isStatic="true" />\n</manifest>'
Code2="!!brut.androlib.meta.MetaInfo\napkFileName: $APP_DEV$1.apk\ncompressionType: false\ndoNotCompress:\n- resources.arsc\nisFrameworkApk: false\npackageInfo:\n  forcedPackageId: '127'\n  renameManifestPackage: null\nsdkInfo: null\nsharedLibrary: false\nsparseResources: true\nunknownFiles: {}\nusesFramework:\n  ids:\n  - 1\n  tag: null\nversion: 2.4.1\nversionInfo:\n  versionCode: '$API'\n  versionName: $DATE$ADR"
echo "$Code1" > "$AndroidManifest"
echo "$Code2" > "$ApktoolJson"
# Copy strings vào ứng dụng đã tạo
APP="$1"
SRC="${APP}"
RES="$APP.apk/res"
if [ -d "$APK_UNPACK$SRC" ] && [ -d "$LINK_DOWNLOAD$RES" ]; then
ECHO_BACKGROUND_BLUE "[$SRC]"
cp -Rf "$LINK_DOWNLOAD$RES" "$APK_UNPACK$SRC"
else
ECHO_BACKGROUND_RED "[$SRC]"
fi; }

# Giải mã ứng dụng | Cảm ơn a Hiếu Kakathic đã hướng dẫn 
DECOMPILER() {
if [ ! "$(ls -A $APK_IMPORT)" ]; then
    ECHO_TEXT_RED "! Không có ứng dụng nào để dịch ngược\n"; ECHO_BACKGROUND_RED "\n[Bấm enter để thoát]"
    read; SELECT_NUMBER
fi
ECHO_TEXT_GOLD "> Đang giải nén apk hàng loạt...\n" | tee log/ToolsVH.log; echo -n "\e[0m"
rm -rf $FOLDER_TOOLS/tmp/*
for vv in $(ls $APK_IMPORT); do
echo "\e[32m--------------------------------------------"; bin/apktool_lite d -f $APK_IMPORT/$vv -o $APK_UNPACK/${vv%.*} 2>&1 | tee -a log/ToolsVH.log; done; ECHO_TEXT_GREEN_1 "--------------------------------------------\n√ Giải nén hoàn tất\n"; ECHO_BACKGROUND_RED "\n[Bấm enter để thoát]"; read; SELECT_NUMBER; }

REPACK() { # Đóng gói ứng dụng | Cảm ơn a Hiếu Kakathic đã hướng dẫn
if [ ! "$(ls -A $APK_UNPACK)" ]; then
    ECHO_TEXT_RED "! Không có ứng dụng nào để đóng gói\n"; ECHO_BACKGROUND_RED "\n[Bấm enter để thoát]"
    read; SELECT_NUMBER
fi
ECHO_TEXT_GOLD "> Đang đóng gói apk hàng loạt...\n" | tee log/ToolsVH.log
for vv in $(ls $APK_UNPACK); do
echo "\e[32m---------------------------------------------"; bin/apktool_lite b -c -f $APK_UNPACK/$vv -o tmp/$vv.apk 2>&1 | sed "/W: warning:/d" 2>&1 | tee -a log/ToolsVH.log
bin/apksig tmp/$vv.apk $APK_REPACK/$vv.apk 2>&1 | tee -a log/ToolsVH.log
done
# chcon u:object_r:system_file:s0 $APK_REPACK # lệnh này không dùng được khi mà file cần thay đổi quyền nằm trong thư mục lưu trữ!
rm -fr $FOLDER_TOOLS/tmp*; ECHO_TEXT_GREEN_1 "--------------------------------------------\n√ Đóng gói hoàn tất\n"; ECHO_BACKGROUND_RED "\n[Bấm enter để thoát]"; read; SELECT_NUMBER; }

# Hàm này tìm và sửa strings
EDIT_STRINGS() {
ECHO_TEXT_GOLD "Chuỗi cần tìm: "; read SEARCH
ECHO_TEXT_GOLD "Thay thế thành: "; read REPLACE
sed -i "s/$SEARCH/$REPLACE/g" $ALL_STRINGS  > /dev/null 2>&1
ECHO_TEXT_PURPLE "\n√ Đã thay thế chuỗi: \e[0m$SEARCH "; ECHO_TEXT_PURPLE "thành chuỗi: \e[0m$REPLACE\n"; ECHO_BACKGROUND_RED "\n[Bấm enter để thoát]"; read; SELECT_NUMBER; }

# Hàm này tìm và thay thế
SEARCH_REPLACE_ALL() { sed -i "/$1/s/.*/$2/" $ALL_STRINGS; } # Tìm 1 chữ thay nguyên 1 hàng
SEARCH_REPLACE_ONE() { sed -i "s/$1/$2/g" $ALL_STRINGS; } # Tìm chữ nào thay chữ đó

FIX_BUG() {
ECHO_TEXT_GOLD "> Đang fix bug, chỉnh sửa bản quyền...\n"
SEARCH_REPLACE_ONE "๖ۣۜßεℓ" "TorryTran" # Hiện trên phụ đề
SEARCH_REPLACE_ONE "MIUI.VN" "VietHoaOS" # Hiện trên phụ đề
ECHO_TEXT_GOLD "> Thêm âm lịch vào hệ thống...\n"
SEARCH_REPLACE_ALL '<string name="aod_lock_screen_date">' '<string name="aod_lock_screen_date">EEE, dd\/MM || e\/N<\/string>'
SEARCH_REPLACE_ALL '<string name="aod_lock_screen_date_12">' '<string name="aod_lock_screen_date_12">EEE, dd\/MM || e\/N<\/string>'
SEARCH_REPLACE_ALL '<string name="status_bar_clock_date_format">' '<string name="status_bar_clock_date_format">EE, dd\/MM || e\/N<\/string>'
SEARCH_REPLACE_ALL '<string name="status_bar_clock_date_format_12">' '<string name="status_bar_clock_date_format_12">EE, dd\/MM || e\/N<\/string>'
SEARCH_REPLACE_ALL '<string name="status_bar_clock_date_time_format">' '<string name="status_bar_clock_date_time_format">H:mm • EEEE, dd\/MM || e\/N YY YYYY<\/string>'
SEARCH_REPLACE_ALL '<string name="status_bar_clock_date_time_format_12">' '<string name="status_bar_clock_date_time_format_12">h:mm aa • EEEE, dd\/MM || e\/N YY YYYY<\/string>'
SEARCH_REPLACE_ALL '<string name="miui_magazine_c_clock_style2_date">' '<string name="miui_magazine_c_clock_style2_date">EE, dd\/MM || e\/N YY<\/string>'
SEARCH_REPLACE_ALL '<string name="format_month_day_week">' '<string name="format_month_day_week">EEEE, dd\/MM || e\/N<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_1">' '<string name="chinese_day_1">01<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_10">' '<string name="chinese_day_10">10<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_11">' '<string name="chinese_day_11">11<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_12">' '<string name="chinese_day_12">12<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_13">' '<string name="chinese_day_13">13<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_14">' '<string name="chinese_day_14">14<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_15">' '<string name="chinese_day_15">15<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_16">' '<string name="chinese_day_16">16<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_17">' '<string name="chinese_day_17">17<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_18">' '<string name="chinese_day_18">18<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_19">' '<string name="chinese_day_19">19<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_2">' '<string name="chinese_day_2">02<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_20">' '<string name="chinese_day_20">20<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_21">' '<string name="chinese_day_21">21<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_22">' '<string name="chinese_day_22">22<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_23">' '<string name="chinese_day_23">23<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_24">' '<string name="chinese_day_24">24<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_25">' '<string name="chinese_day_25">25<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_26">' '<string name="chinese_day_26">26<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_27">' '<string name="chinese_day_27">27<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_28">' '<string name="chinese_day_28">28<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_29">' '<string name="chinese_day_29">29<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_3">' '<string name="chinese_day_3">03<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_30">' '<string name="chinese_day_30">31<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_4">' '<string name="chinese_day_4">04<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_5">' '<string name="chinese_day_5">05<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_6">' '<string name="chinese_day_6">06<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_7">' '<string name="chinese_day_7">07<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_8">' '<string name="chinese_day_8">08<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_day_9">' '<string name="chinese_day_9">09<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_month_january">' '<string name="chinese_month_january">01<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_month_february">' '<string name="chinese_month_february">02<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_month_march">' '<string name="chinese_month_march">03<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_month_april">' '<string name="chinese_month_april">04<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_month_may">' '<string name="chinese_month_may">05<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_month_june">' '<string name="chinese_month_june">06<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_month_july">' '<string name="chinese_month_july">07<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_month_august">' '<string name="chinese_month_august">08<\/string>'
SEARCH_REPLACE_ALL '<string name="chinese_month_september">' '<string name="chinese_month_september">09<\/string>'
} # Kết thúc hàm FIX_BUG

CLEAN_UP() {
# Dọn dẹp file thừa sau khi hoàn tất việt hoá 
ECHO_TEXT_GOLD "> Đang dọn dẹp...\n"
rm -rf $APK_UNPACK*/res/values/
rm -rf $APK_UNPACK*/res/values-mcc460-mnc01-vi
rm -rf $APK_UNPACK*/res/values-mcc460-mnc03-vi
rm -rf $APK_UNPACK*/res/values-mcc460-mnc1-vi-rVN
rm -rf $APK_UNPACK*/res/values-mcc460-mnc01-vi-rVN
rm -rf $APK_UNPACK*/res/values-mcc460-mnc3-vi-rVN
rm -rf $APK_UNPACK*/res/values-mcc460-mnc03-vi-rVN
rm -rf $APK_UNPACK*/original/META-INF/*
rm -rf $FOLDER_TOOLS/MIUI-14-XML-Vietnamese-master
rm -rf $FOLDER_TOOLS/MIUI-14-XML-Vietnamese-master.zip
ECHO_TEXT_GREEN_1 "√ Dọn dẹp xong\n"; }

CLEAR_CACHE() {
ECHO_TEXT_GREEN_1 "> Đang định dạng...\n\n"
rm -rf $FOLDER_TOOLS/.local/*
rm -rf $APK_IMPORT/*
rm -rf $APK_UNPACK/*
rm -rf $APK_REPACK/*
rm -rf $FOLDER_TOOLS/tmp/*
rm -rf $FOLDER_TOOLS/log/ToolsVH.log
ECHO_TEXT_GREEN_1 "√ Đã định dạng\n"; ECHO_BACKGROUND_RED "\n[Bấm enter để thoát]"; read; SELECT_NUMBER; }

DOWNLOAD_STRINGS() {
ECHO_TEXT_GOLD "> Đang xử lý...\n"
mkdir $APK_UNPACK > /dev/null 2>&1
rm -rf $FOLDER_TOOLS/MIUI-14-XML-Vietnamese-master
rm -rf $FOLDER_TOOLS/MIUI-14-XML-Vietnamese-master.zip
sleep 0.5
# Tải gói việt hoá mới nhất của butinhi
ECHO_TEXT_GOLD "> Tải về gói việt hoá mới nhất...\n"
curl --progress-bar --location --remote-header-name --remote-name https://github.com/butinhi/MIUI-14-XML-Vietnamese/archive/refs/heads/master.zip > /dev/null 2>&1
mv -f MIUI-14-XML-Vietnamese-master.zip $FOLDER_TOOLS
if [ -f "$FOLDER_TOOLS/MIUI-14-XML-Vietnamese-master.zip" ]; then
    ECHO_TEXT_GREEN_1 "√ Tải thành công\n"  
else
    ECHO_TEXT_RED "! Lỗi, có vấn đề với việc tải về."
    exit 0
fi
sleep 1
# Giải nén file việt hoá mới tải về
ECHO_TEXT_GOLD "> Đang giải nén...\n"
unzip -o $FOLDER_TOOLS/MIUI-14-XML-Vietnamese-master.zip > /dev/null 2>&1
if [ -d "$LINK_DOWNLOAD" ]; then
    ECHO_TEXT_GREEN_1 "√ Giải nén thành công\n"
else
    ECHO_TEXT_RED "! Lỗi, giải nén thất bại, vui lòng thử lại."
    exit 0
fi
sleep 1; }

# Tạo một ứng dụng overlay, có thể tạo được ứng dụng bên thứ 3 như github... 
CREATE_1_OVERLAY() {
# Tên ứng dụng, nếu không nhập thì tên mặc định sẽ là APK_NO_NAME
ECHO_TEXT_GREEN_2 "Nhập tên ứng dụng: "
read NAME_APK
if [ -z "$NAME_APK" ]; then
   NAME_APK="APK_NO_NAME"
fi
# Tạo tên gói ứng dụng, mặc định là: android.no.package
ECHO_TEXT_GREEN_2 "Nhập tên gói APK: "
read Package
if [ -z "$Package" ]; then
   Package="android.no.package"
fi
# Tên gói overlay thường để tên của tác giả ví dụ tory.overlay.xxx.xxx
ECHO_TEXT_GREEN_2 "Nhập tên gói Overlay: "
read Overlay
if [[ -n "$Overlay" ]]; then
    Overlay_Package="${Overlay}."
fi
# Đặt phiên bản ứng dụng 
ECHO_TEXT_GREEN_2 "Nhập tên phiên bản APK: "
read ADR
if [ -z "$ADR" ]; then
   ADR=""
else
   ADR=" - $ADR"
fi
# Đặt phiên bản api cho ứng dụng 
ECHO_TEXT_GREEN_2 "Nhập số phiên bản APK: "
read API
if [ -z "$API" ]; then
   API="34"
fi
BUILD_APK "$NAME_APK" "$Package" "$Overlay_Package" > /dev/null 2>&1
# Thông tin ứng dụng vừa tạo
ECHO_TEXT_GREEN_1 "\nThông tin ứng dụng đã được tạo:\n"
ECHO_TEXT_PURPLE "Tên APP: \e[0m$NAME_APK\n"
ECHO_TEXT_PURPLE "Tên gói ứng dụng: \e[0m$Package\n"
ECHO_TEXT_PURPLE "Tên gói overlay: \e[0m"$Overlay_Package"overlay.$Package\n"
ECHO_TEXT_PURPLE "Tên phiên bản APK: \e[0m$DATE$ADR\n"
ECHO_TEXT_PURPLE "Số phiên bản APK: \e[0m$API\n"; ECHO_BACKGROUND_RED "\n[Bấm enter để thoát]"; read; SELECT_NUMBER; }

CREATE_ALL_OVERLAY() {
ECHO_TEXT_GREEN_2 "Nhập tên phía trước tên ứng dụng: "
read APP_DEV_NAME
if [[ -n "$APP_DEV_NAME" ]]; then
    APP_DEV="${APP_DEV_NAME}."
fi
ECHO_TEXT_GREEN_2 "Nhập tên phía trước gói overlay: "
read DEV_OVERLAY
if [[ -n "$DEV_OVERLAY" ]]; then
    DEV_OVERLAY_NAME="${DEV_OVERLAY}."
fi
ECHO_TEXT_GREEN_2 "Nhập tên phiên bản APK: "
read ADR
if [ -z "$ADR" ]; then
   ADR=""
else 
   ADR=" - $ADR"
fi
ECHO_TEXT_GREEN_2 "Nhập số phiên bản APK: "
read API
if [ -z "$API" ]; then
   API="34"
fi
ECHO_TEXT_PURPLE "\nTên ứng dụng: \e[0m"$APP_DEV"TenUngDung.apk\n"
ECHO_TEXT_PURPLE "Tên gói overlay: \e[0m"$DEV_OVERLAY_NAME"overlay.TenGoiAPK\n"
ECHO_TEXT_PURPLE "Tên phiên bản APK: \e[0m$DATE$ADR\n"
ECHO_TEXT_PURPLE "Số phiên bản APK: \e[0m$API\n"
echo; DOWNLOAD_STRINGS
ECHO_TEXT_GOLD "> Đang tiến hành việt hoá:\n"
BUILD_APK "AuthManager" "com.lbe.security.miui"
BUILD_APK "Calendar" "com.android.calendar"
BUILD_APK "Cit" "com.miui.cit"
BUILD_APK "CleanMaster" "com.miui.cleanmaster"
BUILD_APK "CloudBackup" "com.miui.cloudbackup"
BUILD_APK "CloudService" "com.miui.cloudservice"
BUILD_APK "Contacts" "com.android.contacts"
BUILD_APK "InCallUI" "com.android.incallui"
BUILD_APK "MiCloudSync" "com.miui.micloudsync"
BUILD_APK "MiGalleryLockscreen" "com.mfashiongallery.emag"
BUILD_APK "MiMover" "com.miui.huanji"
BUILD_APK "MiSettings" "com.xiaomi.misettings"
BUILD_APK "MiShare" "com.miui.mishare.connectivity"
BUILD_APK "MiuiContentCatcher" "com.miui.contentcatcher"
BUILD_APK "MiuiFreeformService" "com.miui.freeform"
BUILD_APK "MiuiGallery" "com.miui.gallery"
BUILD_APK "MiuiHome" "com.miui.home"
BUILD_APK "MiuiPackageInstaller" "com.miui.packageinstaller"
BUILD_APK "MiuiSystemUI" "com.android.systemui"
BUILD_APK "Mms" "com.android.mms"
BUILD_APK "PersonalAssistant" "com.miui.personalassistant"
BUILD_APK "PowerKeeper" "com.miui.powerkeeper"
BUILD_APK "SecurityAdd" "com.miui.securityadd"
BUILD_APK "SecurityCenter" "com.miui.securitycenter"
BUILD_APK "Settings" "com.android.settings"
BUILD_APK "TeleService" "com.android.phone"
BUILD_APK "ThemeManager" "com.android.thememanager"
BUILD_APK "Weather" "com.miui.weather2"
BUILD_APK "XiaomiAccount" "com.xiaomi.account"
BUILD_APK "XiaomiSimActivateService" "com.xiaomi.simactivate.service"
BUILD_APK "com.xiaomi.macro" "com.xiaomi.macro"
BUILD_APK "MiLinkService" "com.milink.service"
BUILD_APK "framework-res" "android"
BUILD_APK "NQNfcNci" "com.android.nfc"
BUILD_APK "MiuiBluetooth" "com.xiaomi.bluetooth"
BUILD_APK "AICallAssistant" "com.xiaomi.aiasst.service"
BUILD_APK "GalleryEditor" "com.miui.mediaeditor"
BUILD_APK "MiAI" "com.miui.voiceassist"
BUILD_APK "MiAITranslate" "com.xiaomi.aiasst.vision"
BUILD_APK "SmartCards" "com.miui.tsmclient"
BUILD_APK "Taplus" "com.miui.contentextension"
BUILD_APK "ContactsProvider" "com.android.providers.contacts"
BUILD_APK "TelephonyProvider" "com.android.providers.telephony"
BUILD_APK "CalendarProvider" "com.android.providers.calendar"
BUILD_APK "Telecom" "com.android.server.telecom"
BUILD_APK "MiuiAod" "com.miui.aod"
BUILD_APK "MiuiCamera" "com.android.camera"
BUILD_APK "MiuixEditor" "com.miui.phrase"
BUILD_APK "DownloadProvider" "com.android.providers.downloads"
BUILD_APK "DownloadProviderUi" "com.android.providers.downloads.ui"
BUILD_APK "PermissionController" "com.android.permissioncontroller"
BUILD_APK "VpnDialogs" "com.android.vpndialogs"
BUILD_APK "MiuiExtraPhoto" "com.miui.extraphoto"
BUILD_APK "Provision" "com.android.provision"
BUILD_APK "Traceur" "com.android.traceur"
ECHO_TEXT_GREEN_1 "\n√ Đã việt hoá xong\n"
sleep 0.5; }
################# END #################

SELECT_NUMBER() {
ECHO_FRAME
ECHO_TEXT_GREEN_2 "1). Tạo app overlay thủ công \n"
ECHO_TEXT_GREEN_2 "2). Tạo app overlay ko âm lịch\n"
ECHO_TEXT_GREEN_2 "3). Tạo app overlay có âm lịch\n"
ECHO_TEXT_GREEN_2 "4). Tìm thay thế từ khoá\n"
ECHO_TEXT_GREEN_2 "5). Dịch ngược toàn bộ ứng dụng\n"
ECHO_TEXT_GREEN_2 "6). Đóng gói toàn bộ ứng dụng\n"
ECHO_TEXT_GREEN_2 "7). Định dạng lại ToolsVH\n"
ECHO_TEXT_GREEN_1 "\nNhập số: "
read Number
if [ "$Number" = "1" ]; then
ECHO_FRAME; CREATE_1_OVERLAY
elif [ "$Number" = "2" ]; then
ECHO_FRAME; CREATE_ALL_OVERLAY; CLEAN_UP; REPACK
elif [ "$Number" = "3" ]; then
ECHO_FRAME; CREATE_ALL_OVERLAY; CLEAN_UP; FIX_BUG; REPACK
elif [ "$Number" = "4" ]; then
ECHO_FRAME; EDIT_STRINGS
elif [ "$Number" = "5" ]; then
ECHO_FRAME; DECOMPILER
elif [ "$Number" = "6" ]; then
ECHO_FRAME; REPACK
elif [ "$Number" = "7" ]; then
ECHO_FRAME; CLEAR_CACHE
else
ECHO_TEXT_RED "! Sai cú pháp, vui lòng chọn lại."
sleep 1; SELECT_NUMBER
fi
}
if [ ! -d $FOLDER_TOOLS ]; then
    ECHO_FRAME
    ECHO_BACKGROUND_RED "! Lỗi, Module chưa được cài đặt"
    exit 0
else
    cd $FOLDER_TOOLS
    SELECT_NUMBER
fi
