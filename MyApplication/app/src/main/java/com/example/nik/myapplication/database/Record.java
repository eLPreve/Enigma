package com.example.nik.myapplication.database;

import com.example.nik.myapplication.Reflector;

/**
 * Created by Preve on 11/07/2014.
 */
public class Record {

    private int id;
    private String clr_text;
    private String cfr_text;
    private String ordineR;
    private String PosR;
    private String switcher;
    private String reflector;

    public Record(int id, String clr_text, String cfr_text, String ordineR, String PosR, String switcher, String reflector) {
        super();
        this.id=id;
        this.clr_text=clr_text;
        this.cfr_text=cfr_text;
        this.ordineR=ordineR;
        this.PosR=PosR;
        this.switcher=switcher;
        this.reflector=reflector;
    }

    public Record() {}

    //Getter

    public String getClr_text(){return clr_text;}
    public String getCfr_text(){return cfr_text;}
    public String getOrdineR(){return ordineR;}
    public String getPosR(){return PosR;}
    public String getSwitcher(){return switcher;}
    public String getReflector(){return reflector;}
    public String getId(){
        return String.valueOf(id);
    }


    //Setter

    public void setClr_text(String x){clr_text=x;}
    public void setCfr_text(String x){cfr_text=x;}
    public void setOrdineR(String x){ordineR=x;}
    public void setPosR(String x){PosR=x;}
    public void setSwitcher(String x){switcher=x;}
    public void setReflector(String x){reflector=x;}
    public void setId(int x){
        id = x;
    }

}