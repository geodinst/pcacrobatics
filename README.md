# Point-Cloud Acrobatics: From Raw LiDAR to Stunning 3D Visuals

Materials for FOSS4g workshop - under construction

## Workshop Outline  
The workshop begins by exploring the [ASPRS standard](https://www.asprs.org/revisions-to-the-asprs-positional-accuracy-standards-for-geospatial-data-2023), helping you understand essential concepts like point classifications, return numbers, and other fundamental attributes that define LiDAR data. You’ll learn how to correctly interpret these attributes, assess data quality, and leverage them for more insightful analysis.

Moving beyond the basics, we’ll dig into powerful open-source workflows with [PDAL](https://pdal.io/), [GRASS](https://grass.osgeo.org/), [WhiteboxTools](https://www.whiteboxgeo.com/) for data reading, manipulation and  spatial processing, and with tools like [QGIS](https://www.qgis.org/), [Potree](https://potree.github.io/) and [pybabylonjs](https://github.com/TileDB-Inc/TileDB-PyBabylonJS) for dynamic 3D rendering. We’ll also introduce [TileDB](https://docs.tiledb.com/main) as a robust storage option to manage point-clouds as massive dataframes. Along the way, we’ll tackle real-world tasks like gridding, interpolation, vectorization, and classification, highlighting  effective approaches to manage and visualize large-scale point clouds in a reproducible manner.

By integrating Python scripts with these specialized tools, you’ll discover how to automate complex processing chains and generate stunning outputs that bring your LiDAR data to life. While basic Python knowledge is helpful, it’s not mandatory — anyone eager to learn new techniques can follow along. By the end of this hands-on workshop, you’ll not only grasp the core concepts behind LiDAR data but also have the practical skills to handle and present it in exciting, visually compelling ways.

The data used was downloaded from [the CLSS portal](https://www.clss.si), which provides LiDA data for Slovenia. The exact tiles used were:
- GKOT_461_100.laz
- GKOT_462_100.laz
- GKOT_461_101.laz
- GKOT_462_101.laz
