import string
import random


def string_generator() -> str:
    length = random.randint(10, 15)
    all_symbols = string.ascii_letters + string.digits

    str = "".join(random.sample(all_symbols, length))
    return str

def append_file():

    with open("python/lesson28/hosts.txt", "a") as f:
        f.write(f"Host: {string_generator()} Login: {string_generator()} Password: {string_generator()}\n" )

def read_file():

    with open("python/lesson28/hosts.txt") as f:
        print(f.read())

def find_host(host:str = ""):

    with open("python/lesson28/hosts.txt") as f:

        for line in f.readlines():

            if host in line:
                print(f"\n{line}")
                return
        
        print(f"\nХост: {host} не найден\n")


while True:

    answer = int(input("1 - Запись в файл\n2 - чтение всего файла\n3 - Найти хост в файле\n4 - выйти\n"))

    match answer:
        case 1:
            append_file()
            print("Добавлена новая запись")
        case 2: 
            read_file()
        case 3:
            host = input("Введите название хоста: ")
            find_host(host)
        case _:
            break


