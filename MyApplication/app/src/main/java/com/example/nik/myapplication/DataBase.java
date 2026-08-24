package com.example.nik.myapplication;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.DrawerLayout;
import android.util.Log;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.nik.myapplication.database.MyDatabase;
import com.example.nik.myapplication.database.Record;


public class DataBase extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_data_base);


        String clr;
        String ordineR;
        int[] PosR = new int[3];
        char[] switcher = new char[20];
        char reflector;

        final String clrr;
        final char[] switcherr = new char[20];
        final String ordineRR;
        final int[] PosRR = new int[3];
        final char reflectorr;

        clr="";
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
        reflectorr=reflector;
        for(int i=0;i<3;i++)
        {
            PosRR[i]=PosR[i];
        }


        final DrawerLayout mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout4);
        String[] option_list = getResources().getStringArray(R.array.Option);
        final ListView list = (ListView)findViewById(R.id.left_drawer4);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),R.layout.row, option_list);

        list.setAdapter(adapter);

        ///////////////////////////////////////////////////



        final ListView listview = (ListView) findViewById(R.id.listview);

        final MyDatabase db = new MyDatabase(getApplicationContext());

        final Custom_Adapter custom_adapter = new Custom_Adapter(getApplicationContext(), R.layout.rowdb,db.getAllRecords());
        listview.setAdapter(custom_adapter);

        registerForContextMenu(listview);



        ///////////////////////////////////////////////////

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
                                                    i.putExtra("Clr_Txt", clrr);
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
        getMenuInflater().inflate(R.menu.menu_data_base, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        switch (item.getItemId()) {

            case R.id.clear_data: {

                Toast alert = Toast.makeText(getApplicationContext(), "Cleared", Toast.LENGTH_SHORT);
                alert.show();
                Log.i("TAG", "Visualizzato toast");

                MyDatabase db = new MyDatabase(getApplicationContext());

                db.deleteTable();

                ListView listview = (ListView) findViewById(R.id.listview);
                Custom_Adapter custom_adapter = new Custom_Adapter(getApplicationContext(), R.layout.row, db.getAllRecords());
                listview.setAdapter(custom_adapter);

                return false;
            }

            default:
                return super.onOptionsItemSelected(item);
        }

    }

    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo){

        Log.i("WOW", "CONTEXT MENU CREATED");



        menu.setHeaderTitle("Opzioni:");
        menu.add(1,1,1,"Dettagli");


    }

    @Override
    public boolean onContextItemSelected(MenuItem item){

        int pos= item.getItemId();
        switch (pos) {
            case 1: {

                AdapterView.AdapterContextMenuInfo ctx = (AdapterView.AdapterContextMenuInfo) item.getMenuInfo();
                int id = ctx.position;

                Record x = new Record();
                MyDatabase db = new MyDatabase(getApplicationContext());
                x=db.getRecordById(id);


                // Create custom dialog object
                final Dialog dialog = new Dialog(DataBase.this);
                // Include dialog.xml file
                dialog.setContentView(R.layout.dialog);
                // Set dialog title
                dialog.setTitle("Info");

                // set values for custom dialog components - text, image and button
                TextView text1 = (TextView) dialog.findViewById(R.id.infClr);
                TextView text2 = (TextView) dialog.findViewById(R.id.infCip);
                TextView text3 = (TextView) dialog.findViewById(R.id.infOrd);
                TextView text4 = (TextView) dialog.findViewById(R.id.infPos);
                TextView text5 = (TextView) dialog.findViewById(R.id.infSwi);
                TextView text6 = (TextView) dialog.findViewById(R.id.infRef);
                text1.setText(x.getClr_text());
                text2.setText(x.getCfr_text());
                text3.setText(x.getOrdineR());
                text4.setText(x.getPosR());
                text5.setText(x.getSwitcher());
                text6.setText(x.getReflector());

                dialog.show();

                return false;
            }
            /*
            case 2: {

                MyDatabase db = new MyDatabase(getApplicationContext());
                db.deleteItem(position + 1);

                ListView listview = (ListView) findViewById(R.id.listview);
                Custom_Adapter custom_adapter = new Custom_Adapter(getApplicationContext(), R.layout.row, db.getAllRecords());
                listview.setAdapter(custom_adapter);

                return false;
            }
            */
            default:
                return super.onContextItemSelected(item);
        }


    }

}
