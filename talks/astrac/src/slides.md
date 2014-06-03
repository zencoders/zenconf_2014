name: inverse
layout: true
class: center, middle, inverse
.hashtag[#zenastrac]

---
#Introduction to Scala and Functional Programming
[Aldo Stracquadanio - Senior Developer @ Footfall123]
---
name: default
layout: true
.hashtag[#zenastrac]

---
.left-column[
  ## Agenda
]

.right-column[

- What is FP?

  - From imperative to functional
  - Referential transparency
  - Referential transparency and purity
  - Benefits

- What is Scala?

  - Type inference
  - Variable definitions
  - Functions
  - Pure OO
  - Classes
  - Traits
  - Singleton objects
  - Case classes
  - Boilerplate reduction in class definitions
  - Implicit conversions
  - Everything is an expression
  - A type safety example: the `Option`
  - Pattern matching
  - Being expressive with higher order functions
]
---
template: inverse

## What is FP?
---
.left-column[
  ## What is FP?
]
.right-column[
Functional Programming is a style of programming which models computations as
the evaluation of expressions. The building blocks of Functional Programming are
*pure functions*.

A function is *pure* when it will not perform any side effects, thus giving the
same output value for the same input arguments independently from when or how many
times it has been invoked. Side effects can be anything like:

- Reassigning a variable
- Modifying a data structure in place
- Setting a field on an object
- Throwing an exception or halting with an error
- Printing to the console or reading user input
- Reading from or writing to a file
- Drawing on the screen
- ...

**Functional programming is a restriction on how we write programs, but not on what
programs we can express.**
]
---
.left-column[
  ## What is FP?
  ### From imperative to functional
]
.right-column[
Let's not consider syntactical aspects for now and have a look at the following
code for a virtual store which will allow a customer to pay using some abstract
`PaymentInfo` (e.g. credit card), a service that connects to an external payment
provider and returns an Item:

```scala
class Store {
  def buyItem(
      info: PaymentInfo, payments: PaymentService): Item = {
    val item = new Item()
    payments.charge(info, item.price) // Side effect!
    item
  }
}
```

This solutions is pretty simple and there wouldn't be anything wrong in an imperative
environment. Nevertheless it has some drawbacks:

- **Unit-testing `buyItem` means that we need to create a mock `PaymentService`**
  implementation that doesn't contact the payment provider

- **This code is not reusable**: if we want to buy multiple items we either call this
  multiple time (maybe incurring in higher delays and payment fees) or create a
  new function that is specific for batching payments introducing duplication
]
---
.left-column[
  ## What is FP?
  ### From imperative to functional
]
.right-column[
**A functional implementation** of the previous code **removes the side effect
by encapsulating it in a value**. This is how it could look like:

```scala
class Store {
  def buyItem(info: PaymentInfo): (Item, Payment) = {
    val item = new Item()
    (item, Payment(item, item.price))
  }
}
```

This implementation achieves a better **separation of concerns** by separating
the *creation of a Payment* from the *processing of that Payment*.

It is now easier to test and reuse this function when making multiple payments.
It could also be possible to merge multiple payments by providing a method as the following:

```scala
case class Payment(info: PaymentInfo, price: Double) {
  def combine(other: Payment): Payment =
    if (other.info == info)
      Payment(info, price + other.price)
    else
      throw new Exception("Cannot combine payments")
}
```
]
---
.left-column[
  ## What is FP?
  ### Referential transparency
]
.right-column[
Referential transparency is a main point in functional programming; a formal
definition of it could be:

**An expression e is referentially transparent if for all programs p, all
occurrences of e in p can be replaced by the result of evaluating e,
without affecting the observable behavior of p.**

Let's take the first example of `Store`:

```scala
class Store {
  def buyItem(info: PaymentInfo, payments: PaymentService): Item = {
    val item = new Item()
    payments.charge(info, item.price) // Side effect!
    item
  }
}
```

The result of invoking `buyItem(aldoInfo, someService)`is the created item, i.e.
`new Item()`. For this to be referential transparent in all programs I should be
able to replace `buyItem(aldoInfo, someService)` with `new Item()` and not change
the meaning of it. This is obviously not true because of the fact that the side
effect would not be performed.

]
---
.left-column[
  ## What is FP?
  ### Referential transparency and purity
]
.right-column[
Using the concept of *referential transparency* we can now give a better and more
formal definition of what a pure function is:

**A function f is pure if the expression f(x) is referentially transparent for
all referentially transparent x.**

People not used to functional programming may wonder now: how do I get anything
actually done in this way if I can't side-effect?

The answer is that there will always be some part of your systems that is going
to side-effect, but all side-effects should be isolated in an outer layer.

A system designed adhering to functional programming principles often exhibits
a **functional core surrounded by an imperative shell** which materializes all
the effects.
]
---
.left-column[
  ## What is FP?
  ### Benefits
]
.right-column[
Programming by pure functions helps building software that is **easier to test** as
side effects are separated from the business rules.

Programming by pure functions helps achieving **higher degrees of parallelism**: when
state is immutable it can be safely shared between threads and processes without
the need for locks.

Programming by pure functions helps being **concise and expressive** through higher order
functions; as an example, given a list of objects of type Person, compare:

```java
List<String> names = new ArrayList<String>();
Iterator<Person> it = persons.iterator();

while (it.hasNext()) {
  names.add(it.next().getName());
}
```

```scala
val names = persons.map(_.name)
```

A program written with pure functions is **easier to follow and to reason about**.

Functional languages often exhibit **very advanced type systems** that help ensuring
correctness.
]
---
template: inverse

## What is Scala?
---



.left-column[
  ## What is Scala?
]
.right-column[
  Scala is a concise, modern, multi-paradigm, statically-typed language

  - Created by Martin Odersky (main contributor for the JVM generics support) in the 2003

  - Supported by Typesafe and the EPFL (École polytechnique fédérale de Lausanne)

  - Runs on the JVM

  - Seamlessly interoperate with existing Java libraries

  - Blends Object Oriented and Functional programming

  - Advanced support for concurrency and distributed systems

  - Still young but gaining traction in the industry
]
---
.left-column[
  ## What is Scala?
  ### Type inference
]
.right-column[
  Type inference reduce the noise in your code by making optional obvious type annotations:

  In Java:
  ```java
  int n = 42;
  String s = "The answer";

  Map<String, Integer> m =
    new HashMap<String, Integer>();
  l.put(s, n);
  ```

  In Scala using the type inference:
  ```scala
  val n = 42
  val s = "A string"
  val m = Map(s -> n)
  ```

  In Scala with explicit type annotations:
  ```scala
  val n: Int = 42
  val s: String = "A string"
  val m: Map[String, Int] = Map(s -> n)
  ```

  The inferred type will be used at compile-time as if the type was specified
  explicitly.
]
---
.left-column[
  ## What is Scala?
  ### Type inference
]
.right-column[
  When working with multiple types that share a common ancestor the inference
  is smart enough to find the type that you probably want. Pretending that we
  have a `Dog` and a `Cat` class extending an `Animal` class.

  ```scala
  val animals = Array(new Dog(), new Cat())
  ```

  In this case `animals` will have type `Array[Animal]` because is the most specific
  type that is appropriate for both the arguments provided.

  The extreme case is as follows:

  ```scala
  val arr = Array(new Dog(), 1, "Foo")
  ```

  In this case `arr` will have type `Array[Any]`, where `Any` is the topmost
  class in Scala's class hierarchy.
]
---
.left-column[
  ## What is Scala?
  ### Variable definitions
]
.right-column[
  Variables can be defined as val or var:

  - *val* are constants.

    ```scala
    val answer = 42
    // ...
    answer = 43 // Compile error
    ```

    - vals can also be *lazy*, in which case their value will be computed only
      when accessed the first time.

      ```scala
      lazy val x = "Some big computation"
      ```

  - *var* are variables

    ```scala
    var x = "Initialization value"
    // ...
    x = "Some other value" // Compiles
    ```

    - vars are usually discouraged in public APIs as immutability is always
      preferred.
    - They are useful when correctly encapsulated to simplify otherwise
      complex logic or when they make it easier to achieve better performances.
]
---
.left-column[
  ## What is Scala?
  ### Functions
]
.right-column[
  Basic function definition:

  ```scala
  def foo(bar: String, baz: String) {
    println(s"Bar: $bar - Baz: $baz")
  }

  foo("A", "B") // prints "Bar: A - Baz: B"
  ```

  Default parameters and named parameter invocations:

  ```scala
  def foo(bar: String = "A", baz: String = "B") {
    println(s"Bar: $bar - Baz: $baz")
  }

  foo()    // prints "Bar: A - Baz: B"
  foo("C") // prints "Bar: C - Baz: B"
  foo(baz = "D") // prints "Bar: A - Baz: D"
  ```

  Despite having a `return` keyword, its use is discouraged. The value returned
  by a function and in general the value of any block is the last value encountered
  in the block.
]
---
.left-column[
  ## What is Scala?
  ### Pure OO
]
.right-column[
  Everything is an object, no primitive types

  ```scala
  val one = 1.toString // -> "1"
  ```

  Every operation is a method call, so these two statements are equivalent:

  ```scala
  val six = 1 + 2 + 3 // -> 6
  ```

  ```scala
  val six = 1.+(2).+(3) // -> 6
  ```

  Syntactic sugar allow omission of **.** and **( )**, so these two statements
  are equivalent as well:

  ```scala
  val c = "Something".charAt(1) // Returns 'o'
  ```

  ```scala
  val c = "Something" charAt 1 // Returns 'o'
  ```
]
---
.left-column[
  ## What is Scala?
  ### Classes
]
.right-column[
  Classes in Scala are purely dynamic (i.e. no static keyword) and can be abstract.
  Class definition works pretty much in the same way as in Java:

```scala
abstract class Animal(val name: String) {
  def speak(): Unit // abstract method
  override def toString = name // override is required
}

class Cat extends Animal("cat") {
  override def speak() { // override here is optional
    println("Meow!")
  }
}

val cat = new Cat // Instantiation
val dog = new Animal("dog") { // Anonymous class
  override def speak() { println("Woof!") }
}

cat.speak() // prints Meow!
dog.speak() // prints Woof!
```

  The equivalent of Java's **Object** is **Any**: all classes inherit from it. There is also
  a type named **Nothing** which inherits from all the classes.
]
---
.left-column[
  ## What is Scala?
  ### Traits
]
.right-column[
  Traits are the Scala equivalent of interfaces, but they allow for concrete
  implementations as well and it is still possible to mix multiple traits in the
  same class:

```scala
trait Animal {
  def call: String
  def speak() {
    println(call)
  }
}

trait Flying {
  def fly() {
    println("I'm flying!")
  }
}

class Bird extends Animal with Flying {
  def call = "cheep"
}

val b = new Bird

b.speak() // prints "cheep"
b.fly() // prints "I'm flying!"
```
]
---
.left-column[
  ## What is Scala?
  ### Singleton objects
]
.right-column[
  As classes do not have a static part Scala has a special keyword for singleton objects.

  A singleton object can have the same name as a class, in which case it is defined
  as **companion object**.

  The main difference between a singleton object and a static class in Java is that
  singleton objects can extend classes and traits.

```scala
trait SayHello {
  def name: String
  def message = "Hello " + name + "!"
}

object Hello extends SayHello {
  override def name = "world"

  def world() {
    println(message)
  }
}

Hello.world() // prints "Hello world!"
```
]
---
.left-column[
## What is FP?
### Case classes
]
.right-column[
Scala achieves great conciseness when defining types for immutable objects through
the *case class* construct.

A case class with an empty body is defined as follows:

```scala
case class Person(name: String, age: Int)
```

Doing this Scala will provide for us:

- An immutable Person class with two public properties (name and age)

- A basic toString, equals and hashCode implementation

- Functions on the Person instances to create updated copies of themselves

- A factory function on the Person companion object

- An extractor for pattern-matching over the class (more on this later)

- Some more less frequently used facilities
]
---
.left-column[
## What is FP?
### Case classes
]
.right-column[
Some example usages of the `Person` case class:

```scala
// Use companion object factory method
val alice = Person("Alice", 25)
val bob = Person("Bob", 30)

println(alice.name) // prints "Alice"
println(alice.age) // prints "25"
println(alice) // prints "Person(Alice, 25)"

val alice2 = alice.copy(age = 26)

println(alice2) // prints "Person(Alice, 26)"

val bob2 = Person("Bob", 30)

println(bob == bob2) // prints "True"
println(bob == alice) // prints "False"
println(alice == alice2) // prints "False"

val set = Set(alice, bob)

println(set.contains(alice)) // prints "True"
println(set.contains(alice2)) // prints "False"
```
]
---
.left-column[
  ## What is Scala?
  ### Boilerplate reduction in class definitions
]
.right-column[
  A typical Java "Person" class

  ```java
  public class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
      this.name = name;
      this.age = age;
    }

    public String getName() {
      return name;
    }

    public int getAge() {
      return age;
    }

    public void setName(String name) {
      this.name = name;
    }

    public void setAge(int age) {
      this.age = age;
    }
  }
  ```
]
---
.left-column[
  ## What is Scala?
  ### Boilerplate reduction in class definitions
]
.right-column[
  Same example in Scala

  ```scala
  class Person(var name: String, var age: Int)
  ```

  With custom getter/setter:
  ```scala
  class Person(var name: String, private var _age: Int) {

    def age = _age // Getter

    def age_=(newAge: Int) { // Setter
      println(s"Setting age to $newAge")
      _age = newAge
    }
  }
  ```

  In general this is not how value-object modelling works in Scala: as we already said
  in Functional Programming side-effects and thus mutable state is not a good thing;
  immutable classes and *case classes* are preferred to getters and setters:

  ```scala
  case class Person(name: String, age: Int)
  ```
]
---
.left-column[
  ## What is Scala?
  ### Implicit conversions
]
.right-column[
  Scala supports *implicit conversions* to enrich types by importing definitions
  in scope.

  An implicit conversion is a function that takes an argument of a type and returns
  an argument of another type.

  Implicit conversions will be applied at compile-time when referring to a method
  or a property that doesn't exist in the base type but exists in the converted one.

```scala
class RichString(s: String) {
  def twice = s + s
}

object RichString {
  implicit def toRichString(s: String) =
    new RichString(s)
}

object HelloTwice {
  import RichString._

  def main(args: Array[String]) {
    println("Hello World!\n".twice)
  }
}
```
]
---
.left-column[
## What is Scala?
### Everything is an expression
]
.right-column[
In Scala everything can be evaluated and attributed a type.

As a consequence there is no `void` keyword, the return value of *imperative statements*
has type `Unit` and is usually referred to as ().

*Imperative statements* returning Unit are `while` loops, assignments and
any function returning Unit.

These two are equivalent and correspond to a program that doesn't do anything:

```scala
def main(args: Array[String]) { () }
def main(args: Array[String]): Unit = ()
```

**Unit is the type to be returned when defining a function does something that
is not pure**.

In this sense it helps the developer to be *honest about types*.
]
---
.left-column[
## What is Scala?
### Everything is an expression
]
.right-column[
Another interesting case are exceptions; how can this type-check?

```scala
def sqrt(x: Double): Double =
  if (x < 0) throw new InvalidArgumentException("...")
  else Math.sqrt(x)
```

The answer resides in the type returned by the `throw` keyword: `Nothing`.

This type is provided by Scala and it is **the children of all the types**,
which means that it can be used in place of any other type.

A neat facility provided by the standard Scala library is the following:

```scala
def ??? = sys.error("An implementation is missing")
```

This is really useful when stubbing out functions:

```scala
def doSomething
  (someArgs: SomeInputTypes): SomeResultType = ???
```

]
---
.left-column[
## What is Scala?
### A type safety example: the Option
]
.right-column[
Scala has a very flexible type-system which can be used to enforce compile-time
correctness in programs.

In most languages, when we need to express an optional return value, we would use
`null`, giving space for the infamous `NullPointerException` and all sorts of
run-time errors.

```scala
sealed trait Option[T]
case class Some[T](value: T) extends Option[T]
case class None extends Option[Nothing]
```

This can be used as follows:

```scala
def maybeParseInt(s: String): Option[Int] =
  if (s.forAll(_.isNum)) Some(s.toInt)
  else None
```

The power of this type is evident: it encodes in the type-system the fact that a
value can be there or not.

The actual option type has a *monadic interface* which makes it very easy and clean
to work with it.
]
---
.left-column[
## What is Scala?
### Pattern matching
]
.right-column[
In most functional programming languages it is important the concept of conditionally
attribute a value to an expression by de-structuring data types via *pattern-matching*.

Let's use the function that we defined while talking about the `Option` type and
let's see how we can square an integer parsed by our function:

```scala
def squared(x: Option[Int]) = x match {
  case Some(value) => value * value
  case None => None
}

val x = maybeParseInt("2") // x = Some(2)
val y = maybeParseInt("foo") // y = None

println(squared(x)) // prints Some(4)
println(squared(y)) // prints None
```

In real Scala anyway you could have done something like this to be more concise:

```scala
def squared(x: Option[Int]) = x.map(v => v * v)
```
]
---
.left-column[
## What is Scala?
### Being expressive with higher order functions
]
.right-column[
**An higher order function is a function that accepts as parameter another function**.

This is another feature very common in functional languages and it helps achieving
very high degrees of conciseness.

We already saw some examples of them; in the previous slide we wrote:

```scala
def squared(x: Option[Int]) = x.map(v => v * v)
```

A simplified version of the definition of `Option` and `map` could be:

```scala
sealed trait Option[A] {
  def map[B](f: A => B): Option[B] = this match {
    case Some(v) => Some(f(v))
    case None => None
  }
}
```

`map` is an higher order function because it accepts the (`f`) function as argument.
As you can see in the signature in Scala function arguments are statically typed
as any other type.
]
---
.left-column[
## What is Scala?
### Being expressive with higher order functions
]
.right-column[
Higher order functions are widely used in Scala to write concise and expressive
code. Some examples from the collection APIs using the Person class we defined
earlier:

```scala
trait List[A] {
  def groupBy[B](f: A => B): Map[B, List[A]]
  def filter(f: A => Boolean): List[A]
  def map[B](f: A => B): List[B]
  def foldLeft[B](start: B)(f: (B, A) => B): B
}

def peopleByAge(ps: List[Person]):
  Map[Int, List[Person]] = ps.groupBy(_.age)

def underAgePersons(ps: List[Person]): List[Person] =
  ps.filter(_.age >= 18)

def averageAge(ps: List[Person]): Double =
  ps.map(_.age).foldLeft(0.0)(_ + _) / ps.length
```

The underscore `_` is a place-holder for anonymous functions that use only once
the provided parameter(s). The followings are equivalent:

```scala
ps.filter(_.age >= 18)
ps.filter(p => p.age >= 18)
ps.filter((p: Person) => p.age >= 18)
```
]
---
.left-column[
## References
]
.right-column[

- Courses on Coursera (http://coursera.org)

  - Functional Programming in Scala, an introduction from Martin Odersky himself
  - Reactive Programming, a more advanced course on reactive systems in Scala

- Some books

  - Programming in Scala - Martin Odersky - Artima
  - Functional Programming in Scala - Paul Chiusano, Runar Bjarnason - Manning Publications (MEAP)
  - Scala for the Impatient - Cay S. Horstmann - Addison, Wesley

- My blog with a couple of articles on Scala - http://blog.astrac.me
]
---
name: last-page
template: inverse

## Questions?

.footnote[Slideshow created using [remark](http://github.com/gnab/remark).]
