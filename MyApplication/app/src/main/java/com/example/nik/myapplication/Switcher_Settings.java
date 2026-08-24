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




public class Switcher_Settings extends Activity {




    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_switcher__settings);

        String clr="";
        char[] switcher = new char[20];
        String ordineR;
        int[] PosR = new int[3];
        char reflector;

        final String[] switchers = new String[20];

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

        final DrawerLayout mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout1);
        String[] option_list = getResources().getStringArray(R.array.Option);
        final ListView list = (ListView)findViewById(R.id.left_drawer1);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),R.layout.row, option_list);


        list.setAdapter(adapter);


        Spinner a1 = (Spinner)findViewById(R.id.a1);

        String[] aph = getResources().getStringArray(R.array.spinner2);

        ArrayAdapter<String> Sp_adapter = new ArrayAdapter<String>(getApplicationContext(),R.layout.row1,aph);

        a1.setAdapter(Sp_adapter);
        a1.setSelection(((int) switcher[0]) - 65);
        a1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[0] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        Spinner a2 = (Spinner)findViewById(R.id.a2);
        a2.setAdapter(Sp_adapter);
        a2.setSelection(((int) switcher[1]) - 65);
        a2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[1] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner b1 = (Spinner)findViewById(R.id.b1);
        b1.setAdapter(Sp_adapter);
        b1.setSelection(((int) switcher[2]) - 65);
        b1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[2] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        Spinner b2 = (Spinner)findViewById(R.id.b2);
        b2.setAdapter(Sp_adapter);
        b2.setSelection(((int) switcher[3]) - 65);
        b2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[3] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner c1 = (Spinner)findViewById(R.id.c1);
        c1.setAdapter(Sp_adapter);
        c1.setSelection(((int) switcher[4]) - 65);
        c1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[4] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        Spinner c2 = (Spinner)findViewById(R.id.c2);
        c2.setAdapter(Sp_adapter);
        c2.setSelection(((int) switcher[5]) - 65);
        c2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[5] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner d1 = (Spinner)findViewById(R.id.d1);
        d1.setAdapter(Sp_adapter);
        d1.setSelection(((int) switcher[6]) - 65);
        d1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[6] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        Spinner d2 = (Spinner)findViewById(R.id.d2);
        d2.setAdapter(Sp_adapter);
        d2.setSelection(((int) switcher[7]) - 65);
        d2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[7] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner e1 = (Spinner)findViewById(R.id.e1);
        e1.setAdapter(Sp_adapter);
        e1.setSelection(((int) switcher[8]) - 65);
        e1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[8] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        Spinner e2 = (Spinner)findViewById(R.id.e2);
        e2.setAdapter(Sp_adapter);
        e2.setSelection(((int) switcher[9]) - 65);
        e2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[9] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner f1 = (Spinner)findViewById(R.id.f1);
        f1.setAdapter(Sp_adapter);
        f1.setSelection(((int) switcher[10]) - 65);
        f1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[10] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        Spinner f2 = (Spinner)findViewById(R.id.f2);
        f2.setAdapter(Sp_adapter);
        f2.setSelection(((int) switcher[11]) - 65);
        f2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[11] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner g1 = (Spinner)findViewById(R.id.g1);
        g1.setAdapter(Sp_adapter);
        g1.setSelection(((int) switcher[12]) - 65);
        g1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[12] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        Spinner g2 = (Spinner)findViewById(R.id.g2);
        g2.setAdapter(Sp_adapter);
        g2.setSelection(((int) switcher[13]) - 65);
        g2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[13] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner h1 = (Spinner)findViewById(R.id.h1);
        h1.setAdapter(Sp_adapter);
        h1.setSelection(((int) switcher[14]) - 65);
        h1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[14] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        Spinner h2 = (Spinner)findViewById(R.id.h2);
        h2.setAdapter(Sp_adapter);
        h2.setSelection(((int) switcher[15]) - 65);
        h2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[15] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner i1 = (Spinner)findViewById(R.id.i1);
        i1.setAdapter(Sp_adapter);
        i1.setSelection(((int) switcher[16]) - 65);
        i1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[16] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        Spinner i2 = (Spinner)findViewById(R.id.i2);
        i2.setAdapter(Sp_adapter);
        i2.setSelection(((int) switcher[17]) - 65);
        i2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[17] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        Spinner j1 = (Spinner)findViewById(R.id.j1);
        j1.setAdapter(Sp_adapter);
        j1.setSelection(((int)switcher[18])-65);
        j1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[18] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        Spinner j2 = (Spinner)findViewById(R.id.j2);
        j2.setAdapter(Sp_adapter);
        j2.setSelection(((int)switcher[19])-65);
        j2.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switchers[19] = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });


        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                        @Override
                                        public void onItemClick(AdapterView<?> adapterView, View view, int pos, long l) {

                                            switch (pos) {

                                                case 0: {
                                                    list.setItemChecked(pos, true);
                                                    mDrawerLayout.closeDrawer(list);
                                                    Intent i = new Intent(getApplicationContext(), MainActivity.class);
                                                    i.putExtra("Clr_Txt", clrr);
                                                    for(int c=0;c<20;c++)
                                                    {
                                                        switcherr[c]=switchers[c].charAt(0);
                                                    }
                                                    i.putExtra("Switcher", switcherr);
                                                    i.putExtra("Ord_R", ordineRR);
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
                                                    for(int c=0;c<20;c++)
                                                    {
                                                        switcherr[c]=switchers[c].charAt(0);
                                                    }
                                                    i.putExtra("Switcher", switcherr);
                                                    i.putExtra("Ord_R", ordineRR);
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
                                                    for(int c=0;c<20;c++)
                                                    {
                                                        switcherr[c]=switchers[c].charAt(0);
                                                    }
                                                    i.putExtra("Switcher", switcherr);
                                                    i.putExtra("Ord_R", ordineRR);
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
                                                    for(int c=0;c<20;c++)
                                                    {
                                                        switcherr[c]=switchers[c].charAt(0);
                                                    }
                                                    i.putExtra("Switcher", switcherr);
                                                    i.putExtra("Ord_R", ordineRR);
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
        getMenuInflater().inflate(R.menu.menu_switcher__settings, menu);
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
