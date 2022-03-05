# TEXT MINING: DON QUIJOTE
Con este script se obtienen dos cuestiones:
- Gracias al paquete/proyecto gutenbergr se pueden utilizar miles de novelas clásicas. En este caso se carga dentro de R la novela "Don Quijote", se tokeniza por palabra y se obtiene (gracias al léxico de sentimientos afinn) la puntuación por palabras de la novela, siendo representada esta puntuación gráficamente a lo largo de la trama (frases) utilizando un método de suavización LOESS. 
- Se representa también, gracias al paquete wordcloud2, la frecuencia de las palabras en la novela mediante una nube de palabras (eliminando palabras de menos de tres caracteres). 

En este (post de linkedin)[https://www.linkedin.com/posts/adri%C3%A1n-rico-alonso_recomiendo-el-libro-text-mining-with-r-activity-6905827105830244352-lzdQ] puedes ver los gráficos generados si lo deseas.
