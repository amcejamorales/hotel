# Online Shopping Cart Design Activity

1. Q.  What classes does each implementation include? Are the lists the same?  
A. The implementations both use the same list of classes: CartEntry, ShoppingCart, and Order.

2. Q. Write down a sentence to describe each class.  
A. CartEntry: handles pricing of a specific number of the same item.  
ShoppingCart: handles the list of each type of item being purchased and, in the second implementation, the pricing for all items given their quantity.  
Order: handles the overall purchase including pricing with tax.

3. Q. How do the classes relate to each other?  
A. ShoppingCart has a list (array) which can be of type CartEntry. CartEntry handles individual *types* of items, their price, and quantity. Order deals with pricing plus tax for any given ShoppingCart.

4. Q. What data does each class store? How (if at all) does this differ between the two implementations?  
A. In both implementations: CartEntry stores the price and quantity of an individual *type* of item; ShoppingCart stores a list (array), which can be of *type* CartEntry; Order stores a ShoppingCart.

5. Q. What methods does each class have? How (if at all) does this differ between the two implementations?  
A. In the first implementation CartEntry has no methods. In the second it has a 'price' method which returns the total cost for an individual *type* of item (by multiplying the unit price with the quantity).  
In the first implementation ShoppingCart has no methods. In the second it has a 'price' method which returns a total price by iterating over each item in its list of items and adding the item's prices up. This method trusts that each item in the list responds to a method called 'price' and returns the appropriate price given the unit price and quantity.  
In the first implementation Order has a 'total_price' method which iterates over each entry in its shopping cart and multiplies the entry's unit price with its quantity and adds it all up. It then multiplies this subtotal with one plus the sales tax to get the total price.  
In the second implementation Order also has a 'total_price' method, which calculates the subtotal by calling on the shopping cart's 'price' method. It then calculates the overall total by multiplying this subtotal with one plus the sales tax.  

6. Q. Consider the Order#total_price method. In each implementation:
Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?
Does total_price directly manipulate the instance variables of other classes?  
A. In the first implementation, Order knows too much. It knows not only that the shopping cart has entries (data), but also that each entry has a unit price and a quantity (also data). It therefore knows about the data in two different classes. In the second implementation Order only knows that shopping cart responds to a method 'price' and trusts the ShoppingCart class to figure it out. This is a much better option because should any changes arise in ShoppingCart or even in CartEntry, Order doesn't need to know about it and doesn't need to change accordingly (so long as method names remain the same).  
In the first implementation the logic to compute the price is retained in Order, whereas in the second implementation it is delegated to ShoppingCart and CartEntry, "lower level" classes. In the first implementation 'total_price' directly manipulates the instance variables of other classes, whereas in the second implementation it calls upon the methods of other classes.

7. Q. If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?  
A. In the first implementation you would need to modify the 'total_price' method definition in the Order class to use the bulk price instead of the unit price. This doesn't seem like much but it's a big deal because Order doesn't even have this information so any changes to this information shouldn't be reflected in Order.  
In the second implementation you would need to change the 'price' method definition in the CartEntry class to use the bulk price instead of the unit price if bulk quantities were purchased. This seems like the same amount of work as the changes required in the first implementation, but it makes sense for the change to be housed in the CartEntry class. In addition, you wouldn't need to touch the ShoppingCart or the Order classes. They would never even know a change occurred in CartEntry's data (unit price to bulk price).

8. Q. Which implementation better adheres to the single responsibility principle?  
A. The second implementation because no class is aware of the data in another class nor performs behaviors that belong to another class (e.g., in the first implementation Order's 'total_price' method calculates the subtotal, which should be ShoppingCart's job).

9. Q. Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?  
A. The second implementation is more loosely coupled because classes are unaware of the data in another class and therefore instead of calling on other classes' instance variables, they call on other classes' instance methods. They trust that the other method will respond to these method names and that these methods will perform the appropriate behavior. Furthermore, in some cases the classes aren't even aware of the existence of other classes. For example, it's true that the Order class is instantiated with a brand new object of class ShoppingCart. Therefore, class Order knows that class ShoppingCart exists.
However, ShoppingCart is instantiated with an empty array that will presumably be filled with items of class CartEntry, but this won't strictly be the case. ShoppingCart's @entries instance variable can take any items and its 'price' method can still work if these items respond to their own 'price' method. Therefore ShoppingCart can be reused elsewhere AND be unaware of the existence of class CartEntry.

***

# Revisiting Hotel

Before revisiting hotel (and even before submitting my first implementation of it) I knew my ReservationManager was really big and taking on roles that dealt closely with the data associated with other classes. Since this is my biggest class I decided to delegate some of the logic in this class's methods to lower level classes.

### Related to Guest
* find_guest: I delegated part of the logic in find_guest to another method by the same name in Guest.
* generate_guest_id (& generate_block_id): I abstracted the logic to generate both guest and block id's and put it inside a method in the Hotel module (outside of any class).

### Related to Reservation
* reserve_room: In the spirit of single responsibility I extracted the logic that determines a room's rate (based on the input rate and the room's base rate) to a method in the Reservation class. This way reserve_room doesn't have to handle this related, but additional responsibility.

### Related to Block
* generate_block: I delegated the logic that fill's a newly generated block's rooms from generate_block to another method in Block.
* in_block?: I delegated the logic that determines whether a room is in a block's list of rooms to another method in Block.
* find_block: I delegated the part of the logic that determines if the block id in the input matches the block's id to another method in Block.
