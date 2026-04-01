# LanguageRoad 🌍

A full-stack, cloud-hosted web application designed to help users track and study vocabulary across multiple languages. 

**Live Demo:** [https://languageroad.onrender.com](https://languageroad.onrender.com)

## Tech Stack & Architecture

This project was engineered using a modern MVC (Model-View-Controller) architecture, decoupling the database, application server, and client interface.

* **Frontend:** HTML5, CSS3, and JSP (JavaServer Pages) with dynamic, language-specific UI rendering.
* **Backend:** Java Servlets handling business logic and HTTP session management.
* **Database:** Remote MySQL database hosted securely in Europe via Aiven.
* **Containerization:** Packaged using Docker with an official Tomcat 9 / Java 21 runtime environment.
* **Deployment:** Continuously deployed and hosted in the cloud via Render.com.
  
## Key Features
* **Secure Authentication:** User registration and login utilizing HTTP session tracking to ensure privacy.
* **Multi-Tenant Architecture:** Users only see and manage their own personalized vocabulary lists.
* **CRUD Operations:** Complete Create, Read, Update, and Delete functionality for vocabulary words, complete with pronunciation guides and English translations.
* **Theming:** The user interface automatically adapts its color palette and styling based on the specific language being studied (Chinese, Russian, Turkish, or Italian).
* **Cloud-Native:** Fully containerized and deployed to the public internet, accessible from any desktop or mobile device.

## Development Notes

This application was developed locally using Eclipse IDE and tested on a local Apache Tomcat server before being containerized. The database connection is handled securely via a `db.properties` file utilizing the standard `mysql-connector-j` driver.
