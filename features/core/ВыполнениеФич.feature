# encoding: utf-8
# language: ru

Функционал: Выполнение фич
	Как Разработчик
	Я Хочу, чтобы у меня была возможность выполнять фичи из feature-файлов

Сценарий: Выполнение фичи из одного файла

# TODO использовать только пока нет повторного использования шагов
  Когда я выполнил подключение тестового скрипта "ПроверкаГенерации"
	И я подготовил тестовый каталог для фич
	И я подготовил специальную тестовую фичу "ПередачаПараметров"
	И я подставил файл шагов с уже реализованными шагами для фичи "ПередачаПараметров"
  И я запустил выполнение фичи "ПередачаПараметров"
  # Тогда проверка поведения фичи "ПередачаПараметров" закончилась со статусом "Пройден"
	Тогда проверка поведения фичи "ПередачаПараметров" закончилась с кодом возврата 0

Сценарий: Выполнение всех фич из каталога фич проекта

  Когда я получил набор фич из каталога фич проекта исключая текущую фичу
	Тогда проверка поведения каждой фичи из набора фич закончилась с кодом возврата 0

Сценарий: Выполнение фич из каталога

# TODO использовать только пока нет повторного использования шагов
  Когда я выполнил подключение тестового скрипта "ПроверкаГенерации"
	И я подготовил тестовый каталог для фич
	И я подготовил специальную тестовую фичу "ПередачаПараметров"
	И я подставил файл шагов с уже реализованными шагами для фичи "ПередачаПараметров"
  # Тогда проверка поведения фич из каталога "." закончилась со статусом "Пройден"
	Тогда проверка поведения фич из каталога "." закончилась с кодом возврата 0
