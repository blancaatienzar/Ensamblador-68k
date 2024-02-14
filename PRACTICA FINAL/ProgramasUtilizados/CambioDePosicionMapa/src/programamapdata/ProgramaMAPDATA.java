/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package programamapdata;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

/**
 *
 * @author Blanca & Hai Zi
 */
public class ProgramaMAPDATA {

    /**
     * Metodo que cambia la orientacion del mapa
     */
    public static void main(String[] args) {
       
        try ( BufferedReader br = new BufferedReader(new FileReader("MapaMalo.txt"))) {
            String line1 = br.readLine();
            String line2 = br.readLine();
            String line3 = br.readLine();
            String line4 = br.readLine();
            String line5 = br.readLine();
            String line6 = br.readLine();
            String line7 = br.readLine();
            String line8 = br.readLine();
            String line9 = br.readLine();
            String line10 = br.readLine();
            String line11 = br.readLine();
            String line12 = br.readLine();
            String line13 = br.readLine();
            String line14 = br.readLine();
            String line15 = br.readLine();
            

            String[] fields1 = line1.split(",");
            String[] fields2 = line2.split(",");
            String[] fields3 = line3.split(",");
            String[] fields4 = line4.split(",");
            String[] fields5 = line5.split(",");
            String[] fields6 = line6.split(",");
            String[] fields7 = line7.split(",");
            String[] fields8 = line8.split(",");
            String[] fields9 = line9.split(",");
            String[] fields10 = line10.split(",");
            String[] fields11 = line11.split(",");
            String[] fields12 = line12.split(",");
            String[] fields13 = line13.split(",");
            String[] fields14 = line14.split(",");
            String[] fields15 = line15.split(",");
            
            try {
                String nom = "MapaCorrecto.txt";
                FileWriter fic = new FileWriter(nom, true);
                BufferedWriter writer = new BufferedWriter(fic);

                for (int i = 0; i < 126; i++) {

                    String lineaNueva = (fields1[i] + "," + fields2[i] + "," + fields3[i] + "," + fields4[i] + "," + fields5[i]
                            + "," + fields6[i] + "," + fields7[i] + "," + fields8[i] + "," + fields9[i] + "," + fields10[i]
                            + "," + fields11[i] + "," + fields12[i] + "," + fields13[i] + "," + fields14[i] + "," + fields15[i]
                            + ",");

                    writer.write(lineaNueva);
                    writer.newLine();
                }

                try {
                    writer.close();
                    fic.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                } finally {
                    try {
                        fic.close();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            } catch (NumberFormatException e) {
                // Imprimir detalles para depuración
                System.out.println("Error converting");
                e.printStackTrace();
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

       
    }

}
