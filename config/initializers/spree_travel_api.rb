# Allow anonymous access for read actions.
Spree::Api::Config[:requires_authentication] = false
# Allow null fields value.
Spree::Config[:address_requires_state] = false