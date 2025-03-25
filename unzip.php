<?php
$zip = new ZipArchive;
$file = 'tour-transport.zip'; // اسم الملف المضغوط

if ($zip->open($file) === TRUE) {
    $zip->extractTo('./'); // فك الضغط في `public_html`
    $zip->close();
    echo '✅ تم فك ضغط الملفات بنجاح!';
} else {
    echo '❌ فشل فك الضغط!';
}
?>
