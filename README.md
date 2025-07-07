# 🌳 Análisis de Deforestación en Tamarugal y Pica (R + Shiny)

Esta aplicación permite analizar registros de deforestación en la región de Tamarugal y Pica durante el año 2024.\
Fue desarrollada en **R** utilizando el framework **Shiny**, permitiendo una visualización interactiva de los datos a través de una interfaz web.

------------------------------------------------------------------------

## 👨‍💻 Autores

-   Ignacio Barraza\
-   Orlando Rojo

------------------------------------------------------------------------

## 🚀 Instrucciones para clonar y ejecutar la app

### 1. Clonar el repositorio

``` bash
git clone https://github.com/IgnacioBarraza/DeforestacionShiny.git
cd DeforestacionShiny
```

### 2. Abrir en RStudio

-   Abre el archivo `app.R` con **RStudio**

### 3. Instalar paquetes necesarios (una sola vez)

En la consola de RStudio, ejecuta:

``` r
install.packages(c("shiny", "readxl", "dplyr", "ggplot2", "DT", "openxlsx"))
```

### 4. Ejecutar la aplicación

Haz clic en **"Run App"** en la esquina superior derecha de RStudio, o ejecuta:

``` r
shiny::runApp()
```

------------------------------------------------------------------------

## 📁 Estructura esperada del Excel

El archivo Excel que cargues debe contener al menos estas columnas:

-   `Tipo_Arbol`: nombre del árbol talado
-   `Cantidad`: número de árboles talados
-   `Fecha`: fecha del evento (en formato fecha)

------------------------------------------------------------------------

## 📊 Funcionalidades

-   📂 Cargar archivo Excel
-   📈 Gráfico de barras por tipo de árbol
-   📉 Gráfico de líneas con análisis mensual
-   📋 Tabla de frecuencia por tipo de árbol
-   📊 Estadísticas descriptivas: media, mediana, moda, desviación estándar y varianza
-   📤 Exportar todo a un archivo Excel (.xlsx) con múltiples hojas

------------------------------------------------------------------------

## 📜 Licencia

Este proyecto se distribuye bajo la **Licencia MIT**. Es de **código abierto y uso libre**, siempre que se mencione a los autores originales.

------------------------------------------------------------------------

## 📝 Notas

-   Proyecto desarrollado como parte de la asignatura **Inteligencia de Negocios**
-   Lenguaje: **R**
-   Framework: **Shiny**
