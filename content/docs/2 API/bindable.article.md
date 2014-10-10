{{
  properties: {
    category: "api"
  }
}}

BindableObjects are used primarily to synchronize information between Models, Templates, and Views.

Two-way data binding means linking properties of two separate objects - when one changes, the other will automatically update with that change.  It enables much easier interactions between data models and UIs, among other uses outside of MVC.

<!--

### Playground Example

{{#example:"test"}}
{{#block:"index-js"}}
var bindable = require("bindable");

var person = new bindable.Object({
  name: "craig",
  last: "condon",
  location: {
    city: "San Francisco"
  }
});

person.bind("location.zip", function(value) {
  // 94102
}).now();

//triggers the binding
person.set("location.zip", "94102");

//bind location.zip to another property in the model, and do it only once
person.bind("location.zip", { to: "zip", max: 1 }).now();

//bind location.zip to another object, and make it bi-directional.
person.bind("location.zip", { target: anotherModel, to: "location.zip", bothWays: true }).now();

//chain to multiple items, and limit it!
person.bind("location.zip", { to: ["property", "anotherProperty"], max: 1 }).now();


//you can also transform data as it's being bound
person.bind("name", {
  to: "name2",
  map: function (name) {
    return name.toUpperCase();
  }
}).now();
{{/}}
{{/}}

-->
#### value bindable.get(property)

Returns a property on the bindable object

{{#example:"test"}}
{{#block:"index-js"}}
<!--
var bindable = new mojo.Object({ city: { name: "SF" } });
console.log(bindable.get("city"));      // { name: "SF" }
console.log(bindable.get("city.name")); // SF
-->
{{/}}
{{/}}

#### bindable.set(property, value)

Sets a value to the bindable object

{{#example:"test"}}
{{#block:"index-js"}}
<!--
var obj = new mojo.Object();
obj.set("city.name", "SF");
console.log(obj.get("city.name")); // SF
-->
{{/}}
{{/}}

#### bindable.setProperties(properties)

sets multiple properties on the bindable object

{{#example:"test"}}
{{#block:"index-js"}}
<!--
var person = new mojo.Object();
person.setProperties({
  firstName: "Jon",
  lastName: "Doe"
});
console.log(person.get("firstName"), person.get("lastName")); // Jon Doe
-->
{{/}}
{{/}}

#### bindable.has(property)

Returns true if the bindable object has a given property

{{#example:"test"}}
{{#block:"index-js"}}
<!--
var obj = new bindable.Object({ count: 0, male: false, name: "craig" });

console.log(obj.has("count")); // true
console.log(obj.has("male")); // true
console.log(obj.has("name")); // true
console.log(obj.has("city")); // false
-->
{{/}}
{{/}}

#### Object bindable.context()

returns the context of the bindable object.

{{#example:"test"}}
{{#block:"index-js"}}
<!--
var context = {};
var obj     = new mojo.Object(context);

console.log(obj.context() === false); // true
console.log(obj.context() == context); // true

// change context to self
obj.context(obj);

console.log(obj.context() === obj); // true
-->
{{/}}
{{/}}

#### listener bindable.on(event, callback)

adds a new listener to the bindable object

#### bindable.emit(event[,args...])

emits a new event

{{#example:"test"}}
{{#block:"index-js"}}
<!--
var person = new mojo.Object();

person.on("blarg", function (arg1, arg2) {
  console.log(arg1, arg2);
});

person.emit("blarg", "something!", "something again!!");
-->
{{/}}
{{/}}

#### bindable.once(event, callback)

listens to one event, then disposes the listener.

{{#example:"test"}}
{{#block:"index-js"}}
<!--
var person = new mojo.Object();

person.once("blarg", function (arg1, arg2) {
  console.log(arg1, arg2);
});

person.emit("blarg", "something!", "something again!!");
person.emit("blarg", "never caught again!");
-->
{{/}}
{{/}}

#### bindable.removeAllListeners([type])

returns all the listeners on the bindable object

#### binding bindable.bind(from, options)

`options` - the options for the binding
  - `to` - the property to bind to. Can be a `string`, `array`, or `function`
  - `target` - the target bindable object. Default is self
  - `max` - max number of times to run the data-binding
  - `when` - tests the data-bound value before setting
  - `map` - transforms the data-bound value
  - `bothWays` - makes the data-binding bi-directional.


{{#example:"test"}}
{{#block:"index-js"}}
<!--
var obj = new mojo.Object({ name: "craig" });

// bind the name, but transform it to upper case
obj.bind("name", { to: "name2", map: function (name) {
  return String(name).toUpperCase();
}}).now();

console.log(obj.get("name"), obj.get("name2"));
obj.set("name", "jeff");
console.log(obj.get("name"), obj.get("name2"));
-->
{{/}}
{{/}}


#### binding.now()

Executes a binding now

{{#example:"test"}}
{{#block:"index-js"}}
<!--
var person = new mojo.Object({ name: "jeff" });
person.bind("name", function (name, oldName) {
  console.log("binding called, name is: ", name);
}).now();

// above is triggered
person.set("name", "joe");
-->
{{/}}
{{/}}


#### binding.dispose()

Disposes a binding

{{#example:"test"}}
{{#block:"index-js"}}
<!--
var person = new mojo.Object({ name: "jeff" });

var binding = person.bind("name", function (name, oldName) {
  console.log("binding called, name is: ", name);
}).now();

binding.dispose();

person.set("name", "jake"); // binding not triggered
-->
{{/}}
{{/}}


#### Events

Bindable objects emit a few events:

- `change:*` - emitted when a property changes on the bindable object. E.g: `change:location.zip`.
- `change` - emitted when any property changes on the bindable object
- `watching` - emitted when a property is being watched
- `dispose` - emitted when `dispose()` is called on a bindable object

{{#example:"test"}}
{{#block:"index-js"}}
<!--
var person = new mojo.Object({ name: "jeff" });

person.on("change:name", function (newName) {
  console.log("the name changed to", newName);
});

person.on("change", function (key, value) {
  console.log("some value has changed: ", key, "=", value);
});

person.on("watching", function (property) {
  console.log("watching ", property);
});

person.on("dispose", function () {
  console.log("the object was disposed");
});

person.set("name", "james");
person.set("city", "sf");
person.bind("name", function(){}); // trigger watching
person.dispose();
-->
{{/}}
{{/}}
