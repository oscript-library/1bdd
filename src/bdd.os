//----------------------------------------------------------
//This Source Code Form is subject to the terms of the
//Mozilla Public License, v.2.0. If a copy of the MPL
//was not distributed with this file, You can obtain one
//at http://mozilla.org/MPL/2.0/.
//---------------------------------------------------------

///////////////////////////////////////////////////////////////////
// Стартовый модуль синхронизатора

#Использовать tempfiles
#Использовать cmdline
#Использовать logos

#Использовать ".."

Перем Лог;
Перем УдалятьВременныеФайлы;
Перем СохраненныйТекущийКаталог;

Функция Версия()
	Возврат Константы_1bdd.ВерсияПродукта;
КонецФункции // Версия()

//{ Точка входа в приложение
Процедура ОсновнаяРабота()
	Лог = Логирование.ПолучитьЛог("bdd");
	УдалятьВременныеФайлы = Истина;
	СохранитьТекущийКаталог();

	Сообщить(СтрШаблон("BDD for OneScript ver.%1", Версия()));

	Попытка
		Параметры = РазобратьАргументыКоманднойСтроки();
		Если Параметры <> Неопределено Тогда
			КодВозврата = ВыполнитьОбработку(Параметры);
			ЗавершитьСкрипт(КодВозврата);
		Иначе
			ПоказатьИнформациюОПараметрахКоманднойСтроки();
			Лог.Ошибка("Указаны некорректные аргументы командной строки");
			ЗавершитьСкрипт(0);
		КонецЕсли;
	Исключение
		Лог.Ошибка(ОписаниеОшибки());
		ЗавершитьСкрипт(-1);
	КонецПопытки;
КонецПроцедуры
//}

///////////////////////////////////////////////////////////////////
//{ Прикладные процедуры и функции

Функция РазобратьАргументыКоманднойСтроки()

	Если АргументыКоманднойСтроки.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Парсер = СоздатьПарсерКоманднойСтроки();
	Параметры = Парсер.Разобрать(АргументыКоманднойСтроки);

	Возврат Параметры;

КонецФункции

Функция СоздатьПарсерКоманднойСтроки()
	Парсер = Новый ПарсерАргументовКоманднойСтроки();

	ДобавитьКомандуExec(Парсер);
	ДобавитьКомандуGenerate(Парсер);
	ДобавитьКомандуHelp(Парсер);
	ДобавитьАргументыПоУмолчанию(Парсер);

	Возврат Парсер;
КонецФункции // СоздатьПарсерКоманднойСтроки()

Процедура ДобавитьКомандуExec(Знач Парсер)

	Команда = Парсер.ОписаниеКоманды("exec", "Выполняет сценарии BDD для Gherkin-спецификаций
		|	bdd exec <features-path> [ключи]
		|");

	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ПутьФичи", 
		"или <features-path> - путь к файлам *.feature.
		|	Можно указывать как каталог, так и конкретный файл.");

	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-name", "
	|	-name <ЧастьИмениСценария> - Выполнение сценариев, в имени которого есть указанная часть");

	Парсер.ДобавитьПараметрФлагКоманды(Команда, "-fail-fast", 
			"Немедленное завершение выполнения на первом же не пройденном сценарии");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-junit-out", 
			" -junit-out <путь-файла-отчета> - выводить отчет тестирования в формате JUnit.xml
	|");// перевод строки нужен для визуального отделения общих ключей в подсказке
	
	ДобавитьОбщиеПараметрыКоманд(Парсер, Команда);
	Парсер.ДобавитьКоманду(Команда);

КонецПроцедуры

Процедура ДобавитьКомандуGenerate(Знач Парсер)

	Команда = Парсер.ОписаниеКоманды("gen", "Создает заготовки шагов для указанных Gherkin-спецификаций
		|	bdd gen <features-path> [ключи]
		|");

	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ПутьФичи", 
		"или <features-path> - путь к файлам *.feature.
		|	Можно указывать как каталог, так и конкретный файл.");
	
	ДобавитьОбщиеПараметрыКоманд(Парсер, Команда);
	Парсер.ДобавитьКоманду(Команда);

КонецПроцедуры

Процедура ДобавитьОбщиеПараметрыКоманд(Парсер, Команда)
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-require",
		"
			|	-require <путь каталога или путь файла> - путь к каталогу фича-файлов или к фича-файлу, 
			|															содержащим библиотечные шаги.
			|	Если эта опция не задана, загружаются все os-файлы шагов из каталога исходной фичи и его подкаталогов.
			|	Если опция задана, загружаются только os-файлы шагов из каталога фича-файлов или к фича-файла, 
			|															содержащих библиотечные шаги.
			|"	);

	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-out", "<путь лог-файла>");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-debug", 
		"-debug <on|off> - включает режим отладки (полный лог + остаются временные файлы)");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-verbose", "-verbose <on|off> - включается полный лог");
КонецПроцедуры

Процедура ДобавитьКомандуHelp(Знач Парсер)

	Команда = Парсер.ОписаниеКоманды("help", "Детальное описание команд");

	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "КомандаДляСправки");
	Парсер.ДобавитьКоманду(Команда);

КонецПроцедуры

Процедура ДобавитьАргументыПоУмолчанию(Знач Парсер)

	Парсер.ДобавитьПараметр("ПутьФичи");

	Парсер.ДобавитьИменованныйПараметр("-require");
	Парсер.ДобавитьИменованныйПараметр("-name");
	Парсер.ДобавитьПараметрФлаг("-fail-fast");
	Парсер.ДобавитьИменованныйПараметр("-junit-out");

	Парсер.ДобавитьИменованныйПараметр("-out");
	Парсер.ДобавитьИменованныйПараметр("-debug");
	Парсер.ДобавитьИменованныйПараметр("-verbose");

КонецПроцедуры

Функция ВыполнитьОбработку(Знач Параметры)

	Если ТипЗнч(Параметры) = Тип("Структура") Тогда
		Команда = Параметры.Команда;
		Параметры = Параметры.ЗначенияПараметров;
	Иначе
		Команда = "exec";
	КонецЕсли;

	ПутьФичи = Параметры["ПутьФичи"];

	УстановитьРежимОтладкиПриНеобходимости(Параметры);
	НастроитьВыводЛогФайла(Параметры);

	КодВозврата = ВыполнитьКоманду(Команда, ПутьФичи, Параметры);

	Возврат КодВозврата;
КонецФункции

Функция ВыполнитьКоманду(Знач Команда, Знач ПутьФичи, Знач Параметры)

	КодВозврата = 0;
	Если Команда = "exec" Тогда
		КодВозврата = ВыполнитьФичу(ПутьФичи, Параметры["-require"], Параметры["-fail-fast"], Параметры["-name"], 
			Параметры["-junit-out"]);
	ИначеЕсли Команда = "gen" Тогда
		СгенерироватьФайлыШагов(ПутьФичи, Параметры["-require"]);
	ИначеЕсли Команда = "help" Тогда
		ВывестиСправкуПоКоманде(Параметры["КомандаДляСправки"]);
	Иначе
		ВызватьИсключение "Неизвестная команда: " + Команда;
	КонецЕсли;

	Возврат КодВозврата;
КонецФункции

Функция ВыполнитьФичу(Знач ПутьФичи, Знач ПутьКБиблиотекам, Знач ИспользоватьБыстрыйОстановНаОшибке, 
		Знач ИмяЭлементаСценария, Знач ПутьОтчетаJUnit)

	Лог.Отладка("ПутьФичи %1", ПутьФичи);
	ТекущийКаталогСохр = ТекущийКаталог();

	ПутьИсполнителя = ОбъединитьПути(ТекущийСценарий().Каталог, "bdd-exec.os");
	Лог.Отладка("Создаю исполнителя. Путь %1", ПутьИсполнителя);
	ИсполнительБДД = Новый ИсполнительБДД;

	ДопЛог = Логирование.ПолучитьЛог(ИсполнительБДД.ИмяЛога());
	ДопЛог.УстановитьУровень(Лог.Уровень());

	ФайлФичи = ПолучитьФайлПоПути(ПутьФичи);
	
	ФайлБиблиотек = ПолучитьФайлБиблиотек(ФайлФичи, ПутьКБиблиотекам);

	СтатусВыполнения = ИсполнительБДД.ВозможныеСтатусыВыполнения().НеВыполнялся;
	ИскатьВПодкаталогах = Истина;

	РезультатыВыполнения = ИсполнительБДД.ВыполнитьФичу(ФайлФичи, ФайлБиблиотек, ИскатьВПодкаталогах, 
			ИспользоватьБыстрыйОстановНаОшибке, ИмяЭлементаСценария);

	УстановитьТекущийКаталог(ТекущийКаталогСохр);

	Если РезультатыВыполнения.Строки.Количество() > 0 Тогда
		СтатусВыполнения = ИсполнительБДД.ПолучитьИтоговыйСтатусВыполнения(РезультатыВыполнения);

		ИсполнительБДД.ВывестиИтоговыеРезультатыВыполнения(РезультатыВыполнения, ФайлФичи.ЭтоКаталог());
	КонецЕсли;

	Если Не ПустаяСтрока(ПутьОтчетаJUnit) Тогда
		ГенераторОтчетаJUnit = Новый ГенераторОтчетаJUnit;
		ГенераторОтчетаJUnit.Сформировать(РезультатыВыполнения, СтатусВыполнения, ПутьОтчетаJUnit);
	КонецЕсли;

	КодВозврата = ИсполнительБДД.ВозможныеКодыВозвратовПроцесса()[СтатусВыполнения];
	Возврат КодВозврата;
КонецФункции

Процедура СгенерироватьФайлыШагов(Знач ПутьФичи, Знач ПутьКБиблиотекам)
	Лог.Отладка("ПутьФичи %1", ПутьФичи);

	ПутьГенератора = ОбъединитьПути(ТекущийСценарий().Каталог, "bdd-generate.os");
	Лог.Отладка("Создаю помощника для генерации файла шагов. Путь %1", ПутьГенератора);
	ГенераторШагов = Новый ГенераторШагов;

	ДопЛог = Логирование.ПолучитьЛог(ГенераторШагов.ИмяЛога());
	ДопЛог.УстановитьУровень(Лог.Уровень());

	ФайлФичи = ПолучитьФайлПоПути(ПутьФичи);
	ФайлБиблиотек = ПолучитьФайлБиблиотек(ФайлФичи, ПутьКБиблиотекам);

	ФайлШагов = ГенераторШагов.СгенерироватьФайлыШагов(ФайлФичи, ФайлБиблиотек);
КонецПроцедуры

Функция ПолучитьФайлБиблиотек(Знач ФайлФичи, Знач ПутьКБиблиотекам)
	Если Не ПустаяСтрока(ПутьКБиблиотекам) Тогда
		ФайлБиблиотек = ПолучитьФайлПоПути(ПутьКБиблиотекам);
		Лог.Отладка("Использую путь к библиотечным шагам %1", ПутьКБиблиотекам);
	Иначе
		//по умолчанию загружаем все файлы шагов из каталога фичи и подкаталогов для использования в качестве библиотечных шагов
		ПутьКаталогаФичи = ?(ФайлФичи.ЭтоКаталог(), ФайлФичи.ПолноеИмя, ФайлФичи.Путь);
		Лог.Отладка("Использую автозагрузку библиотечных шагов из %1", ПутьКаталогаФичи);
		ФайлБиблиотек = Новый Файл(ПутьКаталогаФичи);
	КонецЕсли;
	Возврат ФайлБиблиотек;
КонецФункции // ()

Функция ПолучитьФайлПоПути(Знач Путь)
	РезФайл = Новый Файл(Путь);
	Если Не ЗначениеЗаполнено(РезФайл.Путь) Тогда 
		РезФайл = Новый Файл(ОбъединитьПути(ТекущийКаталог(), Путь));
	КонецЕсли;
	Возврат РезФайл;
КонецФункции // ПолучитьФайлПоПути()


Процедура УстановитьРежимОтладкиПриНеобходимости(Знач Параметры)
	Если Параметры["-debug"] = "on" Тогда
		Лог.УстановитьУровень(УровниЛога.Отладка);
		УдалятьВременныеФайлы = Ложь;
	КонецЕсли;
	Если Параметры["-verbose"] = "on" Тогда
		Лог.УстановитьУровень(УровниЛога.Отладка);
	КонецЕсли;
КонецПроцедуры

Процедура НастроитьВыводЛогФайла(Знач Параметры)
	ИмяЛогФайла = Параметры["-out"];
	Если ИмяЛогФайла <> Неопределено Тогда
		Лог.ДобавитьСпособВывода(Новый ВыводЛогаВКонсоль());
		Аппендер = Новый ВыводЛогаВФайл();
		Аппендер.ОткрытьФайл(ИмяЛогФайла, "utf-8", Ложь);
		Лог.ДобавитьСпособВывода(Аппендер);
	КонецЕсли;
КонецПроцедуры

Процедура ПоказатьИнформациюОПараметрахКоманднойСтроки()

	Сообщить("Выполнение сценариев BDD для Gherkin-спецификаций.");
	Сообщить("Использование: ");
	Сообщить("	bdd <features-path> [ключи] - аналог команды bdd exec");
	Сообщить("	bdd <команда> <параметры команды> [ключи]");

	Парсер = СоздатьПарсерКоманднойСтроки();
	Парсер.ВывестиСправкуПоКомандам();

	Сообщить("Возможные общие ключи:");
	Сообщить("	-out <путь лог-файла>
			|	-debug <on|off> - включает режим отладки (полный лог + остаются временные файлы)
			|	-verbose <on|off> - включается полный лог");

	Сообщить("Для подсказки по конкретной команде наберите bdd help <команда>");

КонецПроцедуры

Процедура ВывестиСправкуПоКоманде(Знач Команда)
	Парсер = СоздатьПарсерКоманднойСтроки();
	Парсер.ВывестиСправкуПоКоманде(Команда);
КонецПроцедуры

Процедура УдалитьВременныеФайлыПриНеобходимости()
	Если УдалятьВременныеФайлы Тогда
		ВременныеФайлы.Удалить();
	КонецЕсли;
КонецПроцедуры

Процедура СохранитьТекущийКаталог()
	СохраненныйТекущийКаталог = ТекущийКаталог();
КонецПроцедуры

Процедура ВосстановитьТекущийКаталог()
	УстановитьТекущийКаталог(СохраненныйТекущийКаталог);
КонецПроцедуры

Процедура ЗавершитьСкрипт(КодВозврата)
	Лог.Закрыть();
	ВосстановитьТекущийКаталог();
	УдалитьВременныеФайлыПриНеобходимости();

	ЗавершитьРаботу(КодВозврата);
КонецПроцедуры
//}

///////////////////////////////////////////////////////////////////

ОсновнаяРабота();
