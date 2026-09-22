# Forager (Game Jam Jaén)
 
Prototipo de videojuego 2D inspirado en **Forager**, desarrollado en **Godot Engine (4.6)** durante la **Game Jam de Jaén**.
 
> ⚠️ **Estado: proyecto sin terminar.** Se desarrolló bajo el límite de tiempo propio de una game jam, por lo que varias mecánicas están incompletas o pendientes de pulido. Se sube como muestra del trabajo realizado durante el evento, no como un juego finalizado.
 
## 🎮 Sobre el proyecto
 
Forager es un juego de recolección y crafteo en el que el jugador explora distintos biomas, recoge recursos, los transforma en herramientas y materiales, e interactúa con distintos NPCs especializados en diferentes oficios.
 
## 🧩 Mecánicas implementadas
 
- **Movimiento y animación** del personaje (idle / caminar) en las 4 direcciones
- **Recolección de recursos**: árboles, arbustos y piedras, cada uno con su propio script de interacción
- **Sistema de inventario básico**: recoger y soltar un ítem con la tecla `E`
- **Estaciones de crafteo**: mesa de trabajo (*workbench*), yunque y horno, cada una con su propia lógica de crafteo
- **NPCs interactivos**: herrero, minero, mago y arqueóloga
- **Herramientas equipables**: hacha y pico, con sus propias animaciones de uso
- **Objeto especial (brújula)**: usada con clic izquierdo
- **3 biomas jugables**: bosque, pradera y desierto, cada uno con su propio tileset
## 🎹 Controles
 
| Acción | Tecla |
|---|---|
| Moverse | `W` `A` `S` `D` |
| Golpear / usar herramienta | Clic izquierdo |
| Abrir inventario / recoger / soltar / craftear | `E` |
 
## 🛠️ Tecnologías utilizadas
 
- **Godot Engine 4.6** (GDScript)
- Renderizado GL Compatibility (compatible con gama baja/media de hardware)
- Sprites y tilesets propios/adaptados para los distintos biomas
## 📁 Estructura del proyecto
 
```
├── Personaje/         # Jugador, herramientas y animaciones
├── Objetos/            # Árboles, arbustos, piedras y recogibles
├── npc/                # Herrero, minero, mago y arqueóloga
├── mesas/              # Estaciones de crafteo (workbench, yunque, horno)
├── escenas/            # Escenas de los biomas (bosque, pradera, desierto)
├── tileMap/            # Tilesets de cada bioma
├── sprites/             # Recursos gráficos
├── animaciones/        # Recursos de animación (SpriteFrames)
├── fonts/              # Tipografía del juego
└── project.godot       # Configuración del proyecto de Godot
```
 
## 🚀 Cómo ejecutarlo
 
1. Descarga e instala [Godot Engine 4.6](https://godotengine.org/download) (o superior compatible).
2. Clona este repositorio:
```bash
   git clone https://github.com/Superiorfran1/forager.git
```
3. Abre Godot, selecciona **Importar** y elige la carpeta del proyecto (`project.godot`).
4. Pulsa **Ejecutar** (▶) para probarlo.
## 🔧 Pendiente / ideas de mejora
 
- Pulir y equilibrar el sistema de crafteo
- Añadir más recetas y recursos
- Sistema de guardado de partida
- Sonido y música
- Menú principal y pantalla de pausa
- Corregir posibles bugs de colisiones e interacción con NPCs
## 👤 Autor
 
**Francisco Cantero Maestro**
- GitHub: [@Superiorfran1](https://github.com/Superiorfran1)
- Email: franciscocm1000@gmail.com
---
 
Proyecto desarrollado con fines de aprendizaje en el contexto de la Game Jam de Jaén.
