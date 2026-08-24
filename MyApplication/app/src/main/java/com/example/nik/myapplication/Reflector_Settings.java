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
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;




public class Reflector_Settings extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_reflector__settings);


        String clr="";
        char[] switcher = new char[20];
        String ordineR;
        int[] PosR = new int[3];
        char reflector;

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

        final DrawerLayout mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout3);
        String[] option_list = getResources().getStringArray(R.array.Option);
        final ListView list = (ListView)findViewById(R.id.left_drawer3);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),R.layout.row, option_list);


        list.setAdapter(adapter);



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



        Spinner riflsp = (Spinner)findViewById(R.id.rifl);

        String[] riflstr = getResources().getStringArray(R.array.riflspinner);

        ArrayAdapter<String> Sp_adapter = new ArrayAdapter<String>(getApplicationContext(),R.layout.row1,riflstr);

        riflsp.setAdapter(Sp_adapter);
        riflsp.setSelection(((int) reflector) - 66);
        riflsp.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                final String selected;
                selected = parent.getItemAtPosition(position).toString();
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
                                                            i.putExtra("Ord_R", ordineRR);
                                                            i.putExtra("Pos_Rot", PosRR);
                                                            //reflector=selected.charAt(0);
                                                            i.putExtra("Rifl", selected.charAt(0));
                                                            startActivity(i);
                                                            break;
                                                        }
                                                        case 1: {
                                                            list.setItemChecked(pos, true);
                                                            mDrawerLayout.closeDrawer(list);
                                                            Intent i = new Intent(getApplicationContext(), Switcher_Settings.class);
                                                            i.putExtra("Clr_Txt", clrr);
                                                            i.putExtra("Switcher", switcherr);
                                                            i.putExtra("Ord_R", ordineRR);
                                                            i.putExtra("Pos_Rot", PosRR);
                                                            //reflector=selected.charAt(0);
                                                            i.putExtra("Rifl", selected.charAt(0));
                                                            startActivity(i);
                                                            break;
                                                        }
                                                        case 2: {
                                                            list.setItemChecked(pos, true);
                                                            mDrawerLayout.closeDrawer(list);
                                                            Intent i = new Intent(getApplicationContext(), Rotor_Settings.class);
                                                            i.putExtra("Clr_Txt", clrr);
                                                            i.putExtra("Switcher", switcherr);
                                                            i.putExtra("Ord_R", ordineRR);
                                                            i.putExtra("Pos_Rot", PosRR);
                                                            //reflector=selected.charAt(0);
                                                            i.putExtra("Rifl", selected.charAt(0));
                                                            startActivity(i);
                                                            break;
                                                        }
                                                        case 3: {
                                                            list.setItemChecked(pos, true);
                                                            mDrawerLayout.closeDrawer(list);
                                                            Intent i = new Intent(getApplicationContext(), Reflector_Settings.class);
                                                            i.putExtra("Clr_Txt", clrr);
                                                            i.putExtra("Switcher", switcherr);
                                                            i.putExtra("Ord_R", ordineRR);
                                                            i.putExtra("Pos_Rot", PosRR);
                                                            //reflector=selected.charAt(0);
                                                            i.putExtra("Rifl", selected.charAt(0));
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
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_reflector__settings, menu);
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
