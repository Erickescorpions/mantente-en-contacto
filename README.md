# Mantente en contacto

## Descripción
**Mantente en contacto** es una aplicación diseñada para ayudarte a mantenerte cerca de las personas que más quieres, sin comprometer tu privacidad.

La app envía notificaciones automáticas a tus contactos cuando llegas a un lugar que tú elijas, sin compartir tu ubicación en tiempo real, sin abrir la app y sin necesidad de enviar mensajes manuales.  
Tú decides qué lugares compartir y con quién compartirlos, manteniendo siempre el control.

---

## Características
- Autenticación segura con **Firebase Auth**.
- Gestión de usuarios y almacenamiento de imágenes de perfil mediante **Firebase Storage**.
- Mapa interactivo con selección de lugares mediante búsqueda o gestos (long press).
- Registro de lugares personalizados directamente desde el mapa.
- Creación de grupos y gestión de miembros.

---

## Descripción del logo
El logotipo muestra dos manos estrechándose, un símbolo universal de **confianza, conexión y apoyo mutuo**.

En *Mantente en contacto*, este gesto representa la esencia de la aplicación: crear vínculos más fuertes con las personas importantes para ti, sin invadir tu privacidad.  
La idea es aprovechar la tecnología para ofrecer tranquilidad a quienes te quieren, permitiéndoles saber que llegaste bien a los lugares importantes en tu día a día, sin necesidad de enviar mensajes ni compartir tu ubicación en tiempo real.

---

## Elección del dispositivo y configuraciones
Para el desarrollo se utilizó el **simulador de iOS** integrado en Xcode, probando principalmente en modelos **iPhone 16** y **iPhone 17**.

Se eligieron estas versiones recientes porque:
1. Permiten probar la app bajo las últimas APIs.
2. Garantizan compatibilidad con la mayoría de dispositivos modernos.

Respecto a las orientaciones soportadas, la app funciona únicamente en **vertical (portrait)** porque:
1. La interacción está optimizada para esta orientación.

---

## Credenciales de acceso para evaluación
Para ingresar a la aplicación:

- **Email:** `erick.vazquez.wk@gmail.com`  
- **Password:** `1234567`

---

## Dependencias del proyecto

### Firebase
- **Firebase Auth** — Autenticación de usuarios  
- **Firebase Firestore** — Base de datos en la nube  
- **Firebase Storage** — Almacenamiento de imágenes  

### Frameworks de iOS
- **UIKit** — Construcción de vistas  
- **MapKit** — Mapas y búsqueda de lugares  
- **CoreLocation** — Ubicación del dispositivo
