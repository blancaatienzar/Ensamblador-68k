/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package imagenes;

/**
 *
 * @author Blanca & Hai Zi
 */
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class Imagenes {

    /*
    * Metodo que imprime por pantalla el codigo BGR de cada pixel de una imagen
    */
    public static void main(String[] args) {
        // Ruta de la imagen
        String imagePath = "floor.png";

        try {
            // Cargar la imagen
            File file = new File(imagePath);
            BufferedImage image = ImageIO.read(file);

            // Obtener el color BGR de cada píxel
            int width = image.getWidth();
            int height = image.getHeight();

            int coma = 0;

            String lineaNueva = " ";

            for (int x = 0; x < height; x++) {
                lineaNueva = ("\n            DC.L    ");
                System.out.print(lineaNueva);
                for (int y = 0; y < width; y++) {
                    int pixel = image.getRGB(x, y);
                    int red = pixel & 0xFF;
                    int green = (pixel >> 8) & 0xFF;
                    int blue = (pixel >> 16) & 0xFF;

                    // Combinar los componentes BGR en formato $00BBGGRR
                    int bgrColor = (red << 16) | (green << 8) | (blue);

                    if (y % 8 == 0 && y != 0) {
                        lineaNueva = ("\n            DC.L    ");
                        System.out.print(lineaNueva);
                    }

                    
                    //Imprimir el resultado
                    lineaNueva = ("$" + String.format("%06X", bgrColor) );
                    System.out.print(lineaNueva);
                    
                    if (coma < 7) {
                        System.out.print(",");
                        coma++;
                    } else {
                        coma = 0;
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
