API RESTFUL (Implementación en Dart)
Descripción
Este proyecto es una aplicación Flutter para gestionar productos. Permite a los usuarios visualizar, crear, editar y eliminar productos. Los productos son gestionados a través de una API REST que facilita la interacción con los datos.

Funciones principales:
Visualizar productos de muestra (solo lectura): Los productos que son proporcionados por la API, que no pueden ser modificados ni eliminados por el usuario.

Gestionar productos creados por el usuario: El usuario puede crear nuevos productos, editarlos y eliminarlos. Estos productos se almacenan de manera local, lo que permite al usuario gestionarlos de manera autónoma.

Interacción con la API: Se realiza una comunicación con una API externa para recuperar y gestionar los productos, utilizando métodos GET, POST, PUT y DELETE.

Características
Pantalla principal: La aplicación muestra dos listas de productos:

Productos de muestra (solo lectura): Una lista de productos proporcionados por la API externa. Estos productos no pueden ser modificados ni eliminados.

Mis productos: Una lista de productos que el usuario ha creado. Estos productos pueden ser editados o eliminados según lo necesite.

Modo oscuro: La aplicación se adapta a un modo oscuro atractivo que proporciona una experiencia visual agradable y cómoda.

Interacción con productos:

Crear producto: Los usuarios pueden agregar nuevos productos a su lista.

Editar producto: Los usuarios pueden editar los productos que han creado.

Eliminar producto: Los usuarios pueden eliminar los productos que han creado.

Justificación de las funciones de eliminar y modificar
Las funcionalidades de modificar y eliminar productos están restringidas a los productos creados por el usuario. Esto se debe a que la API externa utilizada para obtener los productos de muestra no permite la modificación ni eliminación de los mismos.

Para acceder a los productos de muestra, la API devuelve los productos en un formato de solo lectura. Estos productos están disponibles para ser visualizados, pero no pueden ser alterados por el usuario. De esta manera, la aplicación asegura que los productos predeterminados no sean alterados, mientras que los productos creados por el usuario sí pueden ser gestionados de forma completa (creación, edición y eliminación).

API y Gestión de Productos
La aplicación interactúa con la API externa disponible en: https://api.restful-api.dev/objects.

Para obtener los productos de muestra, se realiza una solicitud GET a la API sin ningún filtro. Sin embargo, para obtener los productos que el usuario ha creado, se hace uso de la siguiente estructura de consulta en la API:

bash
Copy
Edit
https://api.restful-api.dev/objects?id=3&id=5&id=10
Cada id representa un producto específico que ha sido creado previamente por el usuario y almacenado localmente. Estos productos pueden ser editados, eliminados y gestionados a través de la aplicación.

Instalación
Clona este repositorio:

bash
Copy
Edit
git clone https://github.com/tuusuario/product-manager-app.git
Navega al directorio del proyecto:

bash
Copy
Edit
cd product-manager-app
Instala las dependencias de Flutter:

bash
Copy
Edit
flutter pub get
Corre la aplicación:

bash
Copy
Edit
flutter run
Tecnologías utilizadas
Flutter: Framework de desarrollo de aplicaciones móviles.

API RESTful: Para la gestión de productos y datos.

SharedPreferences: Para almacenar localmente los productos creados por el usuario.

Licencia
Este proyecto está bajo la Licencia MIT. Consulta el archivo LICENSE para más detalles.

Nota adicional:
Si tienes alguna duda o sugerencia, no dudes en abrir un issue en el repositorio.