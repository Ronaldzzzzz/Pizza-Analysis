# Pizza Price Prediction & Location Analysis

This project analyze the relationship between pizza price and location, then using `Linear Regression` and `Random Forest Regression` to predict the likely price from the given information.
This is the final project for Data Analytics In Bus Using R CS 59000.

## Introduction

### Purpose

The purpose of this project is to present a theoretical business owner with a workup of what the likely price should be for new pizzas. To do so, we will be using two different predictive models, one that is simpler and one that is more complex. The purpose of having two different models is to illustrate how much value could be derived from a more sophisticated approach to solving the problem versus a more straightforward, cheaper solution.

### Intended audience

The intended audience for this project would be the owner of a pizza restaurant that is looking to potentially expand its business or a new owner looking to get started in the pizza business. The final report should not be overly technical, as making a report too technical can often turn off stakeholders and make it more likely that a proposed solution will not be implemented.

## Data

### Data source

The data we used is [Pizza Restaurants and the Pizza They Sell](https://www.kaggle.com/datafiniti/pizza-restaurants-and-the-pizza-they-sell) from [Kaggle](https://www.kaggle.com/) provided by [Datafiniti](https://datafiniti.co/), a company that provides businesses with a wide variety of information on retail products, properties, and companies.
The data is a list of over 3500 pizzas from multiple restaurants across the United States.

### Data size and attribute

The dataset is 4.7 MB unzipped, which does not make the big dataset by any definition, but has 10,000 rows, which makes it large enough for our purposes.
It contains one table with the following attribute:

| Attribute          | Description                                 | Data Format | Example                                                                                                                        |
| ------------------ | ------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------ |
| id                 | *ID of the Pizza*                           | `Character` | `AVz3Y-7h3D1zeR_xDAqm`                                                                                                         |
| dateAdded          | *Date of Adding the Pizza*                  | `UTC`       | `2017-06-30T05:05:40Z`                                                                                                         |
| dateUpdated        | *Date of Updating the Pizza*                | `UTC`       | `2019-05-01T15:43:09Z`                                                                                                         |
| address            | *Store's Address*                           | `Character` | `4203 E Kiehl Ave`                                                                                                             |
| categories         | *Category of the Store*                     | `Character` | `Pizza,Restaurant,American restaurants,Pizza Place,Restaurants`                                                                |
| primaryCategories  | *Primary Category of the Store*             | `Character` | `Accommodation & Food Services`                                                                                                |
| city               | *Store's location (City)*                   | `Character` | `Sherwood`                                                                                                                     |
| country            | *Store's location (Country)*                | `Character` | `US`                                                                                                                           |
| keys               | *A List of Internal Datafiniti Identifiers* | `Character` | `us/ar/sherwood/4203ekiehlave/-1051391616`                                                                                     |
| latitude           | *Store's location (Latitude)*               | `Double`    | `34.8323`                                                                                                                      |
| longitude          | *Store's location (Longitude)*              | `Double`    | `-92.1838`                                                                                                                     |
| menuPageURL        | *URL Pointing to the Menu*                  | `Character` | `http://www.citysearch.com/profile/menu/1550074?singlePlatformId=shotgun-dans-pizza`                                           |
| menus.amountMax    | *Maximum Price Value of the Pizza*          | `Double`    | `7.98`                                                                                                                         |
| menus.amountMin    | *Minimum Price Value of the Pizza*          | `Double`    | `7.98`                                                                                                                         |
| menus.currency     | *Currency Used for the Menu*                | `Character` | `USD`                                                                                                                          |
| menus.dateSeen     | *Date When this Pizza Was Seen*             | `UTC`       | `2018-05-01T04:25:37.197Z,2018-04-16T04:36:02.356Z,2018-02-15T19:58:01.612Z,2018-04-02T23:29:46.353Z,2018-06-28T11:37:25.942Z` |
| menus.description  | *A description for the Pizza*               | `Character` | `Na`                                                                                                                           |
| menus.name         | *The pizza's Name on the Menu*              | `Character` | `Cheese Pizza`                                                                                                                 |
| name               | *Store's name*                              | `Character` | `Shotgun Dans Pizza`                                                                                                           |
| postalCode         | *Zip Code of the Store*                     | `Character` | `72120`                                                                                                                        |
| priceRangeCurrency | *Currency Used for the Pizza*               | `Character` | `USD`                                                                                                                          |
| priceRangeMin      | *Minimum Price Range of the Store*          | `Double`    | `0`                                                                                                                            |
| priceRangeMax      | *Maximum Price Range of the Store*          | `Double`    | `25`                                                                                                                           |
| province           | *Store's location (Province)*               | `Character` | `AR`                                                                                                                           |

## Content

Check the [Pizza-Analysis.md]() out to see the whole report.

## Contributors

* KunJung Lin
* [Roshan Kotian](https://github.com/roshkotian)
* [Mark Trovinger](https://github.com/marktrovinger)
