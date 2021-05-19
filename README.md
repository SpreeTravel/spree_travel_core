Spree Travel Core
=========
Spree Travel Core is intended to be a part of [Spree Travel](https://github.com/openjaf/spree_travel/), providing spree e-commerce platform with the essential functionalities to behave as a travel agency management platform. This means that this spree extension will add new models, behaviors, views, etc… to spree, and will modify some of the definition it holds.

###Important Note
The Spree Travel project is a work in progress, and will suffer major changes. Please use it and keep a live feedback with the team by opening a [GitHub issue](https://github.com/openjaf/spree_travel_core/issues/new).

Requirements
------------
### Rails and Spree
Spree Travel Core now requires Rails version **>= 6.0** and a Spree version **>=4.0**.

Installation
------------

Make a normal Spree installation as followed:

add to the Gemfile:

- gem 'spree', github: 'spree/spree', branch: '4-0-stable'
- gem 'spree_auth_devise', github: 'spree/spree_auth_devise', :branch => '4-0-stable'

then:

rails g spree:install

after testing the installation and everything goes right, add to the Gemfile this dependencies for SpreeTravel:

- gem 'spree_travel_core', github: 'SpreeTravel/spree_travel_core', branch: '4-0-stable'
- gem 'spree_travel_car', github: 'SpreeTravel/spree_travel_car', branch: '4-0-stable'
- gem 'spree_travel_sample', github: 'SpreeTravel/spree_travel_sample', branch: '4-0-stable'

Run this command in this order:

- rails g spree_travel_core:install
- rails g spree_travel_car:install
- rails spree_travel_sample:load PRODUCT_TYPE=car

Features
------------

- Adds the concept of **ProductType** to spree, allowing to create common functionalities for a specific type of product for the Travel Industry.
- ProductTypes has three important concepts **variant_option_types**, **context_option_types**, **rates_option_types**
- Adds the concept of **Context** to spree, providing the logic for creating reservations on an specific tim.
- Adds the concept of **Rates** to spree. Simplifying the logic of different prices in different times in the year.
- Final prices of products are no more in Variants, now are in Rate depending on the Context
- Adds Calculators and search logics on the main page of spree. It simplifies the user experience when searching for products with different specifications.
- Calculator are where the final price is calculated according to each business logic
- Each ProductType is defined in different gems so can be used for example by Rental Cars companies or Transfer Companies, selling only one ProductType.
- Natural Spree products can coexist, they can be sold together

Contributing
------------

If you'd like to contribute a feature or bugfix: Thanks! To make sure your
fix/feature has a high chance of being included, please read the following
guidelines:

1. Post a [pull request](https://github.com/SpreeTravel/spree_travel_core/compare/).
2. Or open a [GitHub issue](https://github.com/SpreeTravel/spree_travel_core/issues/new).

License
-------
Copyright © 2021 OpenJAF, released under the New BSD License.
