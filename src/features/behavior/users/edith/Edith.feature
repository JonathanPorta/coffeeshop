Feature: Site is available
	As a user of our site
	Edith wants to see the site
	So that she knows it exists

	Scenario: Direct Browsing
		Given Edith has her browser open
		When Edith goes to the url directly
		Then she should see "coffeeshop" in the "title"

Feature: Site loads
	As a coffee enthusiast
	Edith wants to the site to load
	So she can order coffee merch

	Scenario: Landing bootstrap
		Given Edith has her browser open
		When she goes to the landing page
		Then she should see "coffeeshop" in the title
		And she should see "Products" in the "header"
