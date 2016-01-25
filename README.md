Make a normal Spree instalation as followed:

add to the Gemfile:

gem 'spree', github: 'spree/spree', branch: '3-0-stable'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', :branch => '3-0-stable'

then:

rails g spree:install

after testing the instalation and everything goes right, add to the Gemfile this dependencies for SpreeTravel:

gem 'spree_travel_core', github: 'openjaf/spree_travel_core', branch: '3-0-stable'
gem 'spree_travel_cruise', github: 'openjaf/spree_travel_cruise', branch: '3-0-stable'
gem 'spree_travel_hotel', github: 'openjaf/spree_travel_hotel', branch: '3-0-stable'
gem 'spree_travel_tour', github: 'openjaf/spree_travel_tour', branch: '3-0-stable'
gem 'spree_travel_car', github: 'openjaf/spree_travel_car', branch: '3-0-stable'
gem 'spree_travel_sample', github: 'openjaf/spree_travel_sample', branch: '3-0-stable'

Run this command in this order:

rails g spree_travel_core:install
rails g spree_travel_hotel:install
rails g spree_travel_car:install
rails g spree_travel_cruise:install
rails g spree_travel_tour:install
rake spree_travel_sample:load PRODUCT_TYPE=hotels ##this one will take a while, please look at the console
rake spree_travel_sample:load PRODUCT_TYPE=cars
rake spree_travel_sample:load PRODUCT_TYPE=tours
rake spree_travel_sample:load PRODUCT_TYPE=cruises ##this product has fixed season datea in year 2016


Spree Travel Core
=========
Spree Travel Core is intended to be a part of [Spree Travel](https://github.com/openjaf/spree_travel/), providing spree e-commerce platform with the essential functionalities to behave as a travel agency management platform. This means that this spree extension will add new models, behaviors, views, etc… to spree, and will modify some of the definition it holds.

###Important Note
The Spree Travel project is a work in progress, and will suffer major changes. Please use it and keep a live feedback with the team by opening a [GitHub issue](https://github.com/openjaf/spree_travel_core/issues/new).

Requirements
------------
### Rails and Spree
Spree Travel Core now requires Rails version **>= 4.0** and a Spree version **>=2.3**.

Installation
------------

Spree Travel Core is not yet distributed as a gem, so it should be used in your app with a git reference or you can download the source and build the gem on your own.

1. Add the following to your Gemfile

  ```ruby
		gem 'spree_travel_core’, :github => 'openjaf/spree_travel_core.git', :branch => '3-0-stable'
  ```

2. Run `bundle install`

3. To copy and apply migrations run:

	```
	rails g spree_travel_core:install
	```

Features
------------

- Adds the concept of types of products to spree, allowing to create common functionalities for a specific type of product.
- Removes the shipping logic from spree no needed on travel agencies.
- Adds the concept of **Context** to spree, providing the logic for creating reservations on an specific tim.
- Adds the concept of **Rates** to spree. Simplifying the logic of different prices in different times of the year.
- Adds new calculators and search logics on the main page of spree. It simplifies the user experience when searching for products with different specifications.


Contributing
------------

If you'd like to contribute a feature or bugfix: Thanks! To make sure your
fix/feature has a high chance of being included, please read the following
guidelines:

1. Post a [pull request](https://github.com/openjaf/spree_travel_core/compare/).
2. Or open a [GitHub issue](https://github.com/openjaf/spree_travel_core/issues/new).

License
-------
Copyright © 2015 OpenJAF, released under the New BSD License.
