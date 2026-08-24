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
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.nik.myapplication.database.MyDatabase;
import com.example.nik.myapplication.database.Record;


public class MainActivity extends Activity {






    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        String clr;
        String ordineR;
        int[] PosR = new int[3];
        char[] switcher = new char[20];
        char reflector;

        final char[] switcherr = new char[20];
        final String ordineRR;
        final int[] PosRR = new int[3];
        final char reflectorr;



        final EditText clear_text = (EditText)findViewById(R.id.cltxt);
        final TextView cript_text = (TextView)findViewById(R.id.cripttxt);


        //INIZIALIZZO DATI

        clr=clear_text.getText().toString().replace(" ","").toUpperCase();
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
            {
                clr = bun.getString("Clr_Txt");
                clear_text.setText(clr);
            }
            if(bun.getCharArray("Switcher")!=null)
            switcher=bun.getCharArray("Switcher");
            if(bun.getString("Ord_R")!=null)
            ordineR=bun.getString("Ord_R");
            if(bun.getIntArray("Pos_Rot")!=null)
                PosR=bun.getIntArray("Pos_Rot");
            if(bun.getChar("Rifl")=='B'||bun.getChar("Rifl")=='C')
            reflector=bun.getChar("Rifl");
        }


        final DrawerLayout mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        String[] option_list = getResources().getStringArray(R.array.Option);
        final ListView list = (ListView)findViewById(R.id.left_drawer);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),R.layout.row, option_list);

        list.setAdapter(adapter);


        Button canc = (Button) findViewById(R.id.btn2);
        canc.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Toast notif = Toast.makeText(getApplicationContext(), "Cancellato", Toast.LENGTH_SHORT);
                notif.show();

                clear_text.setText("");
                cript_text.setText("");

            }
        });


        Button crpt = (Button)findViewById(R.id.btn);

        for(int i=0;i<20;i++)
        {
            switcherr[i]=switcher[i];
        }
        for(int i=0;i<3;i++)
        {
            PosRR[i]=PosR[i];
        }
        reflectorr=reflector;
        ordineRR=ordineR;

        crpt.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                //CONFIGURAZIONE PLUGBOARD

                Plugboard plugboard = new Plugboard();
                plugboard.init();

                //Configuro plugboard

                for (int i = 0; i < 20; i=i+2) {
                    String cable="";
                    cable=cable+switcherr[i];
                    cable=cable+switcherr[i+1];
                    if(cable.toString().charAt(0)!=cable.toString().charAt(1))
                    plugboard.config(cable.toString());
                }


            //CONFIGURAZIONE ROTORI

            String ordine = ordineRR;
            //ordine=ordineR.toString();

            int N_r = 3;
            Rotore[] Vect = new Rotore[3];
                Rotore Static_Rotor = new Rotore();
            Static_Rotor.setName('0');
            Static_Rotor.init();



            for(int i=0;i<N_r;i++)//CREAZIONE ROTORI
            {
                Vect[i]= new Rotore();
                Vect[i].setName(ordine.charAt(i));
                Vect[i].init();
            }


            //ordina(Vect, N_r, ordine);

                    Rotore[] rot_copy = new Rotore[N_r];
                    for(int i=0;i<N_r;i++)
                    {
                        rot_copy[i]=Vect[i];
                    }

                    for(int i=0;i<N_r;i++)
                    {
                        for(int j=0;j<N_r;j++)
                        {
                            if(ordine.charAt(i)==rot_copy[j].getName())
                                Vect[i]=rot_copy[j];
                        }
                    }


            int[] pos_zero= new int[N_r];
                for(int i=0;i<N_r;i++)
                {
                    pos_zero[i]=PosRR[i];
                }
            for(int i = 0;i<N_r;i++)
            {
                for (int j = 0; j < 26; j++) {
                    if (Vect[i].getLetter(0,'R') == (pos_zero[i] + 64)) {
                    } else {
                        Vect[i].scatta();
                    }
                }
            }

            //CONFIGURAZIONE RIFLETTORE
            Reflector rifl = new Reflector();
            char cod;
            cod=reflectorr;
            rifl.setName(cod);
            rifl.init();


            //MAIN
            String str_inserimento= clear_text.getText().toString().replace(" ","").toUpperCase();
            String str_OUT = "";


            int[] counter = new int[N_r];
            for(int j = 0;j<N_r;j++)
            {
                counter[j] = 0;
            }

            for(int i = 0; i<str_inserimento.length();i++)
            {
                char letter;
                letter = str_inserimento.charAt(i);

                //PLUGBOARD ANDATAA
                letter = plugboard.scambia(letter);
                //STATIC_ROTOR
                int ind;
                ind = Static_Rotor.contact(letter, false);
                letter = Vect[0].getLetter(ind, 'R');
                //ROTORI ANDATA
                for (int j = 0; j < N_r; j++) {
                    int indice;
                    indice = Vect[j].contact(letter, true);
                    letter = Vect[j].getLetter(indice, 'L');
                }
                //RIFLETTORE
                ind = rifl.contact(letter, true);
                letter = rifl.getLetter(ind, 'L');
                //ROTORI RITORNO
                for (int j = N_r; j > 0; j--) {
                    int indice;
                    indice = Vect[j - 1].contact(letter, false);
                    letter = Vect[j - 1].getLetter(indice, 'R');
                }
                //STATIC_ROTOR
                ind = Vect[0].contact(letter, true);
                letter = Static_Rotor.getLetter(ind, 'L');
                //PLUGBOARD RITORNO
                letter = plugboard.scambia(letter);


                str_OUT = str_OUT + letter;


                //MOVIMENTO PERIODICO ROTORI
                Vect[0].scatta();

            }

            cript_text.setText(str_OUT);


        }



    });


        Button add = (Button) findViewById(R.id.btn1);
        add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Toast notif = Toast.makeText(getApplicationContext(),"Aggiunto",Toast.LENGTH_SHORT);
                notif.show();

                Record newRecord = new Record();
                newRecord.setClr_text(clear_text.getText().toString());
                newRecord.setCfr_text(cript_text.getText().toString());

                String x="";
                for(int i=0;i<PosRR.length;i++)
                {
                    if(i!=2)
                        x=x+Integer.toString(PosRR[i])+",";
                    else
                        x=x+Integer.toString(PosRR[i]);
                }
                newRecord.setPosR(x);

                String y="";
                for(int i=0;i<switcherr.length;i++)
                {
                    if(i!=0&&i%2==0) y=y+","+Character.toString(switcherr[i]);
                    else     y=y+Character.toString(switcherr[i]);
                }
                newRecord.setSwitcher(y);
                newRecord.setOrdineR(ordineRR.charAt(0)+","+ordineRR.charAt(1)+","+ordineRR.charAt(2));
                newRecord.setReflector(Character.toString(reflectorr));


                MyDatabase db = new MyDatabase(getApplicationContext());
                db.addRecord(newRecord);
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
                                                    i.putExtra("Clr_Txt", clear_text.getText().toString());
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
                                                    i.putExtra("Clr_Txt", clear_text.getText().toString());
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
                                                    //clr = clear_text.getText().toString();
                                                    i.putExtra("Clr_Txt", clear_text.getText().toString());
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
                                                    i.putExtra("Clr_Txt", clear_text.getText().toString());
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
                                                    i.putExtra("Clr_Txt", clear_text.getText().toString());
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
        getMenuInflater().inflate(R.menu.main, menu);
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
