#!/bin/sh


#<li><a href="datahtml/2021-01-04.html">2021-01-04</a></li>
{
while IFS= read -r Line; do
	printf "%s\n" "$Line";
done <<EOF
<!DOCTYPE html>
<html lang="ru">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta charset="utf-8">
	<title>Архив показаний температуры воздуха в Бийске</title>
	<meta name="description" content="Архив показаний температуры воздуха в Бийске">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="icon" href="data:image/svg+xml,&lt;svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22&gt;&lt;text y=%22.9em%22 font-size=%2290%22&gt;%E2%9D%84%EF%B8%8F&lt;/text&gt;&lt;/svg&gt;">
	<link rel="stylesheet" href="style.css">
</head>
<body>
	<main>
		<header>
			<h1>
				Архив показаний температуры воздуха в Бийске
			</h1>
			<hr>
		</header>
		<section>
		<h2>Содержимое</h2>
		<p>
			Сайт содержит архив показаний температуры в городе Бийск,
			Алтайский край.
		</p>
		<p>
			Запись ведется начиная с вечера (20:05, по Бийскому времени)
			4 января 2021 года и по сей день.
		</p>
		</section>
		<section>
		<h2>Источники данных</h2>
		<p>Данные берутся каждую минуту с <a href="http://www.bti.secna.ru/web-thermo/data">WEB-термометра</a> <a href="http://miscoi.narod.ru/">МиСЦОИ</a> <a href="http://www.bti.secna.ru/">(БТИ АлтГТУ)</a>.</p>
		<p>Планируется автономный сбор данных, при помощи электронного термометра.</p>
		</section>
		<section>
		<h2>Формат данных</h2>
		<p>Данные о температуре воздуха разбиты по файлам, по дням. Имя каждого файла имеет вид:</p>
		<p class="ind">ГГГГ-ММ-ДД.txt</p>
		<p>Каждая строка файла – запись. Формат записи:</p>
		<p class="ind"><u>температура в Цельсиях</u>;<u>дата в формате iso-8601 до секунд, пояс UTC+07:00</u></p>
		<p class="ind">-30,6;2021-01-04T20:05:10+07:00</p>
		<p>Для каждого дня также создана своя веб-страничка с читаемой таблицей.</p>
		</section>
		<section class="list">
		<h2>Измерения:</h2>
<ul id="artlist">
EOF


for line in $(ls datahtml)
do
	echo '<li><a href="datahtml/'"$line""\">"$(echo $line | sed -e 's/.html//g')"</a></li>" 
done

while IFS= read -r Line; do
	printf "%s\n" "$Line";
done <<EOF
</ul>
		</section>
	<section>
	<hr>
	<p>Дизайн позаимствован у <a href="https://фембой.рф/">фембой.рф</a> и <a href="https://based.cooking/">based.cooking</a></p>
	</section>
	</main>
</body>
</html>
EOF
} > index.html
