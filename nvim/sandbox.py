# IRON REPL Test Playground
# Comprehensive examples to test Iron.nvim REPL functionality

# =============================================================================
# SECTION 1: Basic Variables and Printing
# =============================================================================

y = "hello world"
x = 42
z = [1, 2, 3, 4, 5]

print(f"x = {x}")
print(f"y = {y}")
print(f"z = {z}")

# =============================================================================
# SECTION 2: Function Definitions
# =============================================================================

def greet(name):
    """Simple greeting function"""
    return f"Hello, {name}!"

def calculate_stats(numbers):
    """Calculate mean, median, and std dev"""
    import statistics
    return {
        "mean": statistics.mean(numbers),
        "median": statistics.median(numbers),
        "stdev": statistics.stdev(numbers) if len(numbers) > 1 else 0
    }

# Test function calls
result = greet("Iron")
print(result)

stats = calculate_stats([10, 20, 30, 40, 50])
print(f"Statistics: {stats}")

# =============================================================================
# SECTION 3: Data Structures
# =============================================================================

# Lists and list operations
my_list = [1, 2, 3, 4, 5]
squares = [x**2 for x in my_list]
evens = [x for x in my_list if x % 2 == 0]
print(f"Original: {my_list}")
print(f"Squares: {squares}")
print(f"Evens: {evens}")

# Dictionaries
user_data = {
    "name": "Alice",
    "age": 30,
    "hobbies": ["coding", "reading", "gaming"]
}

for key, value in user_data.items():
    print(f"{key}: {value}")

# =============================================================================
# SECTION 4: Class Definition (Test sending entire class)
# =============================================================================

class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
        self.friends = []
    
    def add_friend(self, friend):
        self.friends.append(friend)
    
    def __repr__(self):
        return f"Person(name='{self.name}', age={self.age})"
    
    def introduce(self):
        return f"Hi, I'm {self.name} and I'm {self.age} years old."

# Create instances and test methods
alice = Person("Alice", 30)
bob = Person("Bob", 25)
alice.add_friend(bob)

print(alice.introduce())
print(f"Alice's friends: {alice.friends}")

# =============================================================================
# SECTION 5: Loops and Control Flow (Good for interrupt testing)
# =============================================================================

# Counter loop - good for testing send_motion (e.g., vip to select this block)
print("Counting to 5:")
for i in range(1, 6):
    print(f"  Count: {i}")

# While loop with break condition
counter = 0
while counter < 3:
    print(f"While loop iteration: {counter}")
    counter += 1

# Nested conditionals
score = 85
if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
else:
    grade = "F"
print(f"Score {score} = Grade {grade}")

# =============================================================================
# SECTION 6: Long Running Code (Test interrupt with <leader>ri)
# =============================================================================

# WARNING: This will run for a while - use <leader>ri to interrupt!
# Uncomment the lines below to test interrupt functionality
# import time
# print("Starting long process...")
# for i in range(1000):
#     time.sleep(0.5)
#     print(f"Iteration {i}")
# print("Done!")

# =============================================================================
# SECTION 7: Error Handling (Test error display in REPL)
# =============================================================================

def risky_division(a, b):
    try:
        result = a / b
        return result
    except ZeroDivisionError as e:
        return f"Error: {e}"
    except Exception as e:
        return f"Unexpected error: {e}"

print(risky_division(10, 2))
print(risky_division(10, 0))

# =============================================================================
# SECTION 8: NumPy and Data Processing (If available)
# =============================================================================

try:
    import numpy as np
    
    # Create arrays
    arr1 = np.array([1, 2, 3, 4, 5])
    arr2 = np.arange(10)
    matrix = np.random.rand(3, 3)
    
    print(f"Array 1: {arr1}")
    print(f"Mean: {arr1.mean()}")
    print(f"Sum: {arr1.sum()}")
    print(f"\nRandom 3x3 matrix:\n{matrix}")
    print(f"\nMatrix transpose:\n{matrix.T}")
    
except ImportError:
    print("NumPy not available - install with: pip install numpy")

# =============================================================================
# SECTION 9: Generator Functions
# =============================================================================

def fibonacci_generator(n):
    """Generate first n Fibonacci numbers"""
    a, b = 0, 1
    count = 0
    while count < n:
        yield a
        a, b = b, a + b
        count += 1

print("First 10 Fibonacci numbers:")
fib_list = list(fibonacci_generator(10))
print(fib_list)

# =============================================================================
# SECTION 10: Interactive Variables (Test REPL state persistence)
# =============================================================================

# Define these variables, then send individual lines to modify them
test_counter = 0
test_message = "initial"

def function_name(args):pass

# After running the above, try sending these individually:
# test_counter += 1
# test_counter += 1
# test_message = "modified"
# print(f"Counter: {test_counter}, Message: {test_message}")

# =============================================================================
# IRON REPL TESTING GUIDE
# =============================================================================
#
# Test <leader>r (send code):
#   1. Place cursor on a line, press <leader>r + motion (e.g., <leader>rap)
#   2. Visually select code (V), press <leader>r to send selection
#
# Test <leader>ri (interrupt):
#   1. Uncomment the long-running code in Section 6
#   2. Send it to REPL
#   3. While it's running, press <leader>ri to interrupt
#
# Test <leader>rq (quit):
#   1. Open REPL with <leader>ro
#   2. Send some code
#   3. Press <leader>rq to quit REPL
#
# Test <leader>rl (clear):
#   1. Send lots of code to fill screen
#   2. Press <leader>rl to clear the REPL display
#
# Test <leader>rh (hide) / <leader>rf (focus):
#   1. Open REPL
#   2. Press <leader>rh to hide (REPL keeps running)
#   3. Press <leader>rf to bring it back
#
# Test <leader>rr (restart):
#   1. Define some variables in REPL
#   2. Press <leader>rr to restart (variables reset)
#   3. Try to print variables - should get NameError
#
# =============================================================================

print("\n" + "="*70)
print("Sandbox loaded! Test Iron REPL with the examples above.")
print("="*70)



