# 연금복권
import random

lotto_number = []

for i in range(1,7):
    number = random.randrange(1, 10)
    lotto_number.append(number)
    
print(lotto_number)
