package com.example.nik.myapplication;

import android.app.Activity;

import android.app.ActionBar;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.support.v4.widget.DrawerLayout;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;





public class Rotor_Settings extends Activity {



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rotor__settings);


        String clr="";
        char[] switcher = new char[20];
        String ordineR;
        int[] PosR = new int[3];
        char reflector;

        final String[] strr = new String[6];
        for(int i=0;i<6;i++)
        {
            strr[i]="";
        }

        final String clrr;
        final char[] switcherr = new char[20];
        final String ordineRR;
        final int[] PosRR = new int[3];
        final char reflectorr;


        //INIZIALIZZO DATI

        for(int i=0;i<20;i++)
        {
            switcher[i]='A';
        }
        for(int i=0;i<3;i++)
        {
            PosR[i]=1;
        }
        ordineR="123";
        reflector='B';


        Bundle bun = getIntent().getExtras();
        if(bun!=null)
        {
            if(bun.getString("Clr_Txt")!=null)
                clr = bun.getString("Clr_Txt");
            if(bun.getCharArray("Switcher")!=null)
                switcher=bun.getCharArray("Switcher");
            if(bun.getString("Ord_R")!=null)
                ordineR=bun.getString("Ord_R");
            if(bun.getIntArray("Pos_Rot")!=null)
                PosR=bun.getIntArray("Pos_Rot");
            if(bun.getChar("Rifl")=='B'||bun.getChar("Rifl")=='C')
                reflector=bun.getChar("Rifl");
        }


        clrr=clr;
        for(int i=0;i<20;i++)
        {
            switcherr[i]=switcher[i];
        }
        ordineRR=ordineR;
        for(int i=0;i<3;i++)
        {
            PosRR[i]=PosR[i];
        }
        reflectorr=reflector;


        final DrawerLayout mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout2);
        String[] option_list = getResources().getStringArray(R.array.Option);
        final ListView list = (ListView)findViewById(R.id.left_drawer2);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),R.layout.row, option_list);


        Spinner sp1 = (Spinner)findViewById(R.id.spinner1);
        Spinner sp2 = (Spinner)findViewById(R.id.spinner2);
        Spinner sp3 = (Spinner)findViewById(R.id.spinner3);


        String[] str = getResources().getStringArray(R.array.spinner);

        ArrayAdapter<String> Sp_adapter = new ArrayAdapter<String>(getApplicationContext(),R.layout.row1,str);

        sp1.setAdapter(Sp_adapter);
        sp1.setSelection(((int) ordineR.charAt(0)) - 49);
        sp1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                strr[0] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });


        sp2.setAdapter(Sp_adapter);
        sp2.setSelection(((int) ordineR.charAt(1)) - 49);
        sp2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                strr[1] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        sp3.setAdapter(Sp_adapter);
        sp3.setSelection(((int) ordineR.charAt(2)) - 49);
        sp3.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                strr[2] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner sp11 = (Spinner)findViewById(R.id.spinner11);
        Spinner sp22 = (Spinner)findViewById(R.id.spinner22);
        Spinner sp33 = (Spinner)findViewById(R.id.spinner33);

        final String[] st1r = getResources().getStringArray(R.array.spinner1);

        ArrayAdapter<String> Sp_adapter1 = new ArrayAdapter<String>(getApplicationContext(),R.layout.row1,st1r);

        sp11.setAdapter(Sp_adapter1);
        sp11.setSelection(PosR[0]-1);
        sp11.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                strr[3] = parent.getItemAtPosition(position).toString();

            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        sp22.setAdapter(Sp_adapter1);
        sp22.setSelection(PosR[1]-1);
        sp22.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                strr[4] = parent.getItemAtPosition(position).toString();

            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        sp33.setAdapter(Sp_adapter1);
        sp33.setSelection(PosR[2]-1);
        sp33.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                strr[5] = parent.getItemAtPosition(position).toString();

            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        list.setAdapter(adapter);

        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                        @Override
                                        public void onItemClick(AdapterView<?> adapterView, View view, int pos, long l) {

                                            switch (pos) {

                                                case 0: {
                                                    list.setItemChecked(pos, true);
                                                    mDrawerLayout.closeDrawer(list);
                                                    Intent i = new Intent(getApplicationContext(), MainActivity.class);
                                                    i.putExtra("Clr_Txt", clrr);
                                                    i.putExtra("Switcher", switcherr);
                                                    //ordineRR=str1+str2+str3;
                                                    i.putExtra("Ord_R", strr[0]+strr[1]+strr[2]);
                                                    PosRR[0]=Integer.parseInt(strr[3]);
                                                    PosRR[1]=Integer.parseInt(strr[4]);
                                                    PosRR[2]=Integer.parseInt(strr[5]);
                                                    i.putExtra("Pos_Rot", PosRR);
                                                    i.putExtra("Rifl", reflectorr);
                                                    startActivity(i);
                                                    break;
                                                }
                                                case 1: {
                                                    list.setItemChecked(pos, true);
                                                    mDrawerLayout.closeDrawer(list);
                                                    Intent i = new Intent(getApplicationContext(), Switcher_Settings.class);
                                                    i.putExtra("Clr_Txt", clrr);
                                                    i.putExtra("Switcher", switcherr);
                                                    //ordineRR=str1+str2+str3;
                                                    i.putExtra("Ord_R", strr[0]+strr[1]+strr[2]);
                                                    PosRR[0]=Integer.parseInt(strr[3]);
                                                    PosRR[1]=Integer.parseInt(strr[4]);
                                                    PosRR[2]=Integer.parseInt(strr[5]);
                                                    i.putExtra("Pos_Rot", PosRR);
                                                    i.putExtra("Rifl", reflectorr);
                                                    startActivity(i);
                                                    break;
                                                }
                                                case 2: {
                                                    list.setItemChecked(pos, true);
                                                    mDrawerLayout.closeDrawer(list);
                                                    Intent i = new Intent(getApplicationContext(), Rotor_Settings.class);
                                                    i.putExtra("Clr_Txt", clrr);
                                                    i.putExtra("Switcher", switcherr);
                                                    //ordineRR=str1+str2+str3;
                                                    i.putExtra("Ord_R", strr[0]+strr[1]+strr[2]);
                                                    PosRR[0]=Integer.parseInt(strr[3]);
                                                    PosRR[1]=Integer.parseInt(strr[4]);
                                                    PosRR[2]=Integer.parseInt(strr[5]);
                                                    i.putExtra("Pos_Rot", PosRR);
                                                    i.putExtra("Rifl", reflectorr);
                                                    startActivity(i);
                                                    break;
                                                }
                                                case 3: {
                                                    list.setItemChecked(pos, true);
                                                    mDrawerLayout.closeDrawer(list);
                                                    Intent i = new Intent(getApplicationContext(), Reflector_Settings.class);
                                                    i.putExtra("Clr_Txt", clrr);
                                                    i.putExtra("Switcher", switcherr);
                                                    //ordineRR=str1+str2+str3;
                                                    i.putExtra("Ord_R", strr[0]+strr[1]+strr[2]);
                                                    PosRR[0]=Integer.parseInt(strr[3]);
                                                    PosRR[1]=Integer.parseInt(strr[4]);
                                                    PosRR[2]=Integer.parseInt(strr[5]);
                                                    i.putExtra("Pos_Rot", PosRR);
                                                    i.putExtra("Rifl", reflectorr);
                                                    startActivity(i);
                                                    break;
                                                }
                                                case 4: {
                                                    list.setItemChecked(pos, true);
                                                    mDrawerLayout.closeDrawer(list);
                                                    Intent i = new Intent(getApplicationContext(), DataBase.class);
                                                    i.putExtra("Clr_Txt", clrr);
                                                    i.putExtra("Switcher", switcherr);
                                                    i.putExtra("Ord_R", ordineRR);
                                                    i.putExtra("Pos_Rot", PosRR);
                                                    i.putExtra("Rifl", reflectorr);
                                                    startActivity(i);
                                                    break;
                                                }
                                            }
                                        }
                                    }
        );

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_rotor__settings, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
