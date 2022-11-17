import random


rand_num = random.randint(1, 20)

while True:

    user_num = int(input("Enter the number: "))

    if user_num == rand_num:
        answer = int(input("You Won! Do you wanna play again? (1-Yes, 2-No): "))

        match answer:
            case 1:
                rand_num = random.randint(1, 20)
                continue
            case 2: 
                break
            case _:
                break

    elif user_num < rand_num:
        print("your number is less")
    elif user_num > rand_num:
        print("your number is bigger")


