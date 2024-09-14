# Classes and objects
class Dog:

    # Define a class attribute
    attr1 = "Mammal"
    no_of_eyes = 2
    no_of_ears = 2

    # Define an instance (function)
    def __init__ (self, name, age):
        self.class_name = name
        self.class_age = age
    
    # Define an instance (function)
    def bark (self):
        print("My name is {}".format(self.class_name))


# Object instantiation
obj_tommy = Dog("Tommy", 10)

print(obj_tommy.attr1, obj_tommy.no_of_ears, obj_tommy.no_of_eyes, obj_tommy.class_name, obj_tommy.class_age )
print(obj_tommy.bark())

# Object instantiation
obj_tiger = Dog("Tiger", 3)

print(obj_tiger.attr1, obj_tiger.no_of_ears, obj_tiger.no_of_eyes, obj_tiger.class_name, obj_tiger.class_age )



# Inheritance

# parent class
class Person:

	# __init__ is known as the constructor
	def __init__(self, name, idnumber):
		self.name = name
		self.idnumber = idnumber

	def display(self):
		print(self.name)
		print(self.idnumber)
		
	def details(self):
		print("My name is {}".format(self.name))
		print("IdNumber: {}".format(self.idnumber))

# object instantiation
obj_james = Person("James", 12345)
obj_james.display()
obj_james.details()

# child class
class Employee(Person):
	def __init__(self, name, idnumber, salary, post):
		self.salary = salary
		self.post = post

		# invoking the __init__ of the parent class
		Person.__init__(self, name, idnumber)
		
	def details(self):
		print("My name is {}".format(self.name))
		print("IdNumber: {}".format(self.idnumber))
		print("Post: {}".format(self.post))


# creation of an object variable or an instance
a = Employee('Rahul', 886012, 200000, "Intern")

# calling a function of the class Person using
# its instance
a.display()
a.details()


# Polymorphism

class India():
    def capital(self):
        print("New Delhi is the capital of India.")

    def language(self):
        print("Hindi is the most widely spoken language of India.")

    def type(self):
        print("India is a developing country.")

class USA():
    def capital(self):
        print("Washington, D.C. is the capital of USA.")

    def language(self):
        print("English is the primary language of USA.")

    def type(self):
        print("USA is a developed country.")

obj_ind = India()
obj_usa = USA()

print(obj_ind.language())

# polymorphism
for country in (obj_ind, obj_usa):
    print(country)
    country.capital()
    # country.language()
    # country.type()