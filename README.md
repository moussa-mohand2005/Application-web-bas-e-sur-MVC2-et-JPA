# E-Commerce Application - MVC2 with JPA

A complete Java EE web application implementing an e-commerce platform using MVC2 architecture (Servlets + JSP/JSTL) with JPA for persistence.

## Features

- **Public Product Showcase** (Vitrine): Browse products, search by keyword, view product details
- **User Authentication**: Register new users, login/logout with secure password hashing (BCrypt)
- **Shopping Cart** (Panier): Add/remove/update products, view cart, checkout
- **Product Management**: Admin interface for CRUD operations on products
- **Responsive Design**: Clean, modern UI with CSS Grid and mobile-first responsive layout

## Technology Stack

- **Java 17**
- **Jakarta EE 10** (Servlets, JSP, JSTL, JPA, CDI)
- **Lombok** (Boilerplate code reduction with annotations)
- **WildFly** (Application Server)
- **MySQL 8** (Database)
- **BCrypt** (Password Hashing)
- **Maven** (Build Tool)

## Architecture

### MVC2 Pattern
- **Model**: JPA Entities (Internaute, Vitrine, Produit, Panier, LignePanier)
- **View**: JSP pages with JSTL (no scriptlets)
- **Controller**: Servlets (AuthServlet, ProduitServlet, PanierServlet, AdminProduitServlet)

### Layers
- **Entities**: Domain model with JPA annotations
- **Repositories**: Data access layer with EntityManager
- **Services**: Business logic with transactional methods
- **Web**: Servlet controllers
- **Filters**: UTF-8 encoding, authentication, CSRF protection

## Database Schema

The application uses the following entities:

- **Internaute**: User account with unique email, hashed password
- **Vitrine**: Product showcase with title and description
- **Produit**: Product with libelle, description, prix, stock, actif status
- **Panier**: Shopping cart with status (OUVERT, VALIDE, ANNULE)
- **LignePanier**: Cart line item linking products and quantities

## Prerequisites

1. **JDK 17** or higher
2. **Maven 3.8+**
3. **MySQL 8.0+**
4. **WildFly 27+** (or any Jakarta EE 10 compatible server)
5. **Lombok Plugin** for your IDE (IntelliJ IDEA, Eclipse, VS Code)

## Database Setup

### 1. Create MySQL Database

**Option A: Using provided SQL script**
```bash
mysql -u root -p < setup-database.sql
```

**Option B: Manual SQL commands**
```sql
CREATE DATABASE jpa CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'jpauser'@'localhost' IDENTIFIED BY 'jpapass';
GRANT ALL PRIVILEGES ON jpa.* TO 'jpauser'@'localhost';
FLUSH PRIVILEGES;
```

### 2. Configure WildFly DataSource

**Method 1: Using WildFly CLI (Recommended)**

**Quick Setup with Script:**

1. Edit `setup-datasource.cli` and update the MySQL connector path to match your system:
   - Replace `C:/Users/LENOVO/` with your actual home directory
   - The path should point to: `.m2/repository/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar`

2. Start WildFly:
```bash
cd %WILDFLY_HOME%\bin
standalone.bat
```

3. In a new terminal, run the script:
```bash
cd %WILDFLY_HOME%\bin
jboss-cli.bat --connect --file=..\..\path\to\project\setup-datasource.cli
```

**Manual Setup:**

1. Start WildFly if not running:
```bash
cd %WILDFLY_HOME%\bin
standalone.bat
```

2. In a new terminal, connect to WildFly CLI:
```bash
cd %WILDFLY_HOME%\bin
jboss-cli.bat --connect
```

3. Execute these commands (replace the path with your actual MySQL connector path):

```bash
module add --name=com.mysql --resources=C:/Users/LENOVO/.m2/repository/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar --dependencies=javax.api,javax.transaction.api

/subsystem=datasources/jdbc-driver=mysql:add(driver-name=mysql,driver-module-name=com.mysql,driver-class-name=com.mysql.cj.jdbc.Driver)

data-source add --name=MySQLDS --jndi-name=java:jboss/datasources/MySQLDS --driver-name=mysql --connection-url=jdbc:mysql://localhost:3306/jpa?useSSL=false&serverTimezone=UTC --user-name=jpauser --password=jpapass --use-ccm=false --max-pool-size=25 --blocking-timeout-wait-millis=5000 --enabled=true --validate-on-match=true --background-validation=false

reload
```

**Method 2: Manual Configuration in standalone.xml**

1. Stop WildFly if running

2. Open `%WILDFLY_HOME%\standalone\configuration\standalone.xml`

3. Add the datasource in the `<datasources>` section (inside `<subsystem xmlns="urn:jboss:domain:datasources:..."`):

```xml
<datasource jndi-name="java:jboss/datasources/MySQLDS" pool-name="MySQLDS" enabled="true" use-java-context="true">
    <connection-url>jdbc:mysql://localhost:3306/jpa?useSSL=false&amp;serverTimezone=UTC</connection-url>
    <driver>mysql</driver>
    <security>
        <user-name>jpauser</user-name>
        <password>jpapass</password>
    </security>
    <validation>
        <validate-on-match>true</validate-on-match>
        <background-validation>false</background-validation>
    </validation>
</datasource>
```

4. Add the MySQL driver in the `<drivers>` section:

```xml
<driver name="mysql" module="com.mysql">
    <driver-class>com.mysql.cj.jdbc.Driver</driver-class>
</driver>
```

5. Create the module directory:
```
%WILDFLY_HOME%\modules\com\mysql\main\
```

6. Copy `mysql-connector-j-8.3.0.jar` to that directory

7. Create `module.xml` in the same directory:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<module xmlns="urn:jboss:module:1.9" name="com.mysql">
    <resources>
        <resource-root path="mysql-connector-j-8.3.0.jar"/>
    </resources>
    <dependencies>
        <module name="javax.api"/>
        <module name="javax.transaction.api"/>
    </dependencies>
</module>
```

8. Start WildFly

## Build and Deploy

### 1. Build the Application

```bash
mvn clean package
```

This creates `target/jpa-1.0-SNAPSHOT.war`

### 2. Deploy to WildFly

**Option A: Copy to deployments directory**
```bash
cp target/jpa-1.0-SNAPSHOT.war $WILDFLY_HOME/standalone/deployments/
```

**Option B: Use WildFly CLI**
```bash
$WILDFLY_HOME/bin/jboss-cli.sh --connect
deploy target/jpa-1.0-SNAPSHOT.war
```

**Option C: Use Maven WildFly Plugin (optional)**

Add to `pom.xml` and run `mvn wildfly:deploy`

### 3. Start WildFly (if not running)

```bash
cd $WILDFLY_HOME/bin
./standalone.sh
```

On Windows:
```cmd
cd %WILDFLY_HOME%\bin
standalone.bat
```

## Access the Application

Once deployed, access the application at:

```
http://localhost:8080/jpa-1.0-SNAPSHOT/
```

Or configure a custom context root in `jboss-web.xml` to use:

```
http://localhost:8080/jpa/
```

## Default Credentials

The application seeds one test user on startup:

- **Email**: `test@example.com`
- **Password**: `password123`

## Application Structure

```
src/main/java/net/moussa/jpa/
├── entities/          # JPA entities
├── repository/        # Data access layer
├── service/           # Business logic
├── web/              # Servlets (controllers)
├── filter/           # Request filters
└── startup/          # Seed data loader

src/main/webapp/
├── WEB-INF/
│   ├── jsp/          # JSP views
│   └── web.xml       # Web application descriptor
└── assets/
    └── css/          # Stylesheets

src/main/resources/META-INF/
├── persistence.xml   # JPA configuration
└── beans.xml         # CDI configuration
```

## URL Routing

### Public Endpoints
- `GET /produits?action=list` - List all active products
- `GET /produits?action=details&id={id}` - View product details
- `GET /produits?action=search&q={keyword}` - Search products

### Authentication
- `GET /auth?action=login` - Login form
- `POST /auth?action=login` - Process login
- `GET /auth?action=register` - Registration form
- `POST /auth?action=register` - Process registration
- `POST /auth?action=logout` - Logout

### Shopping Cart (requires authentication)
- `GET /panier?action=view` - View cart
- `POST /panier?action=add&id={id}&q={qty}` - Add product to cart
- `POST /panier?action=update&id={id}&q={qty}` - Update quantity
- `POST /panier?action=remove&id={id}` - Remove product from cart
- `POST /panier?action=clear` - Clear entire cart
- `POST /panier?action=checkout` - Validate order

### Admin (requires authentication)
- `GET /admin/produits?action=list` - List all products
- `GET /admin/produits?action=create` - Create product form
- `POST /admin/produits?action=create` - Process creation
- `GET /admin/produits?action=edit&id={id}` - Edit product form
- `POST /admin/produits?action=update` - Process update
- `POST /admin/produits?action=delete&id={id}` - Delete product

## Development Notes

### Lombok Integration

This project uses **Lombok** to reduce boilerplate code in entity classes. Lombok provides annotations like:

- `@Getter` / `@Setter` - Generate getter/setter methods automatically
- `@NoArgsConstructor` - Generate no-argument constructor
- `@AllArgsConstructor` - Generate constructor with all fields
- `@Data` - Combines @Getter, @Setter, @ToString, @EqualsAndHashCode, @RequiredArgsConstructor

**IDE Setup:**

For **IntelliJ IDEA**:
1. Install Lombok plugin: File → Settings → Plugins → Search "Lombok" → Install
2. Enable annotation processing: Settings → Build, Execution, Deployment → Compiler → Annotation Processors → Enable annotation processing

For **Eclipse**:
1. Download lombok.jar from https://projectlombok.org/download
2. Run: `java -jar lombok.jar`
3. Select Eclipse installation directory

For **VS Code**:
1. Install "Lombok Annotations Support" extension

### JPA Schema Generation

The application uses `drop-and-create` schema generation for development. For production, change in `persistence.xml`:

```xml
<property name="jakarta.persistence.schema-generation.database.action" value="none"/>
```

### Seed Data

Seed data is automatically loaded on application startup via `DataLoader.java`. It creates:
- 1 test user
- 1 vitrine (product showcase)
- 10 sample products

### Password Security

User passwords are hashed using BCrypt with salt. Never store plain-text passwords.

### CSRF Protection

All POST requests require a valid CSRF token from the session. The token is automatically injected into forms.

## Troubleshooting

### Error: "Required services that are not installed: jboss.naming.context.java.jpa"

**Problem:** WildFly cannot find the datasource.

**Solution:**
1. Verify the datasource is created in WildFly:
```bash
cd %WILDFLY_HOME%\bin
jboss-cli.bat --connect
/subsystem=datasources/data-source=MySQLDS:read-resource
```

2. If the datasource doesn't exist, run the setup script:
```bash
jboss-cli.bat --connect --file=path\to\setup-datasource.cli
```

3. Check MySQL is running:
```bash
mysql -u jpauser -pjpapass jpa
```

### DataSource Not Found

Ensure the MySQL datasource `java:jboss/datasources/MySQLDS` is configured in WildFly and the database is running.

### Tables Not Created

Check that:
1. MySQL is running and database `jpa` exists
2. DataSource connection is valid
3. `persistence.xml` has correct schema generation settings

### Login Issues

The default user is created on first startup. If the database is recreated, restart WildFly to trigger seed data loading.

### Port Conflicts

If port 8080 is in use, modify WildFly's `standalone.xml` to use a different port.

## License

This project is for educational purposes.

