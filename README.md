# American Friends of IMPJ -- Ride for Reform Fundraising Tool
 
## Overview

This is a social fundraising application for riders in the annual IMPJ Ride 4 Reform.

IMPJ hosts an annual ride to raise awareness for Progressive Judaism in Israel.
Riders are participant fundraisers in this week long ride. They commit to a fundraising goal, and solicit funds from their friends and community.
Riders manage their profiles, and direct public traffic to their personal pages. 
Riders may register for new ride years when a new ride year is published by the admin. The application maintains a rider's public-facing profile while allowing them to add new ride years, and fundraise for each ride year. 
 
The app offers a lightweight CMS, an admin layer for access to all data, and to export user and donation data to CSV. 

[Staging Environment Deployed here](https://r4r-take-2-sandbox.herokuapp.com/) with PayPal in sandbox mode. 
Live application is not yet deployed. 

## Dependencies

* Rails 4.1.5 
* Ruby 2.0.0
* PostgreSQL
* AWS S3 storage
* PayPal API v1
* MailGun via SMTP(for easier integration with Rails' ActionMailer)
* Devise
* Bootstrap

## Running Locally 

Clone this repo!
bundle install

You will need API keys for PayPayl, AWS, and SMTP info at MailGun. 
So register and dig around, or if you are interested in contributing, please contact me directly. 



Developed by [Avi Fox-Rosen](https://github.com/avifoxi) with contributions from [Alan Cohen](https://github.com/alancohen), and input from Armen Varten.

 

[Original Spec](https://docs.google.com/document/d/1HaCiJ6or8ZuCRphLkziCouc2JkX5fqHEDdV-8YV6Wms/edit)
