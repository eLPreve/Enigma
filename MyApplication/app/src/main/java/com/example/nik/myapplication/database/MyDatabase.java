package com.example.nik.myapplication.database;


import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.util.LinkedList;
import java.util.List;


/**
 * Created by Preve on 11/07/2014.
 */
public class MyDatabase extends SQLiteOpenHelper {

    private static final int DATABASE_VERSION=1;
    private static final String DATABASE_NAME="Dati";

    // Books table name
    private static final String TABLE_NAME = "Texts";

    // Books Table Columns names
    private static final String KEY_ID = "id";
    private static final String KEY_CLR = "Clear_Text";
    private static final String KEY_CFR = "Cript_Text";
    private static final String KEY_ORD = "OrderR";
    private static final String KEY_POS = "Position";
    private static final String KEY_SWI = "Switcher";
    private static final String KEY_REF = "Reflector";


    public MyDatabase (Context context){
        super(context,DATABASE_NAME,null,DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

        // SQL statement to create records table

        // create books table
        db.execSQL("CREATE TABLE " + TABLE_NAME + " (" +
                KEY_ID+" INTEGER PRIMARY KEY AUTOINCREMENT, " +
                KEY_CLR + " TEXT, " +
                KEY_ORD + " TEXT, " +
                KEY_POS + " TEXT, " +
                KEY_SWI + " TEXT, " +
                KEY_REF + " TEXT, " +
                KEY_CFR + " TEXT )");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // Drop older records table if existed
        db.execSQL("DROP TABLE IF EXISTS "+TABLE_NAME);

        // create fresh records table
        this.onCreate(db);
    }

    public void addRecord(Record record){

        // 1. get reference to writable DB
        SQLiteDatabase db = this.getWritableDatabase();

        // 3. insert
        db.execSQL("INSERT INTO "+TABLE_NAME+" ("+KEY_CLR+", "+KEY_CFR+","+KEY_ORD+", "+KEY_POS+", "+KEY_SWI+", "+KEY_REF+") " +
                "VALUES('"+record.getClr_text()+"', '"+record.getCfr_text()+"', '"+record.getOrdineR()+"', '"+record.getPosR()+
                "', '"+record.getSwitcher()+"', '"+record.getReflector()+"')");
        db.close();

    }

    public Record getRecordById(int id){

        Record r = new Record();


        SQLiteDatabase db = this.getWritableDatabase();
        //db.execSQL("DELETE FROM "+TABLE_NAME+" WHERE "+KEY_ID+" = "+id);
        //db.execSQL("ALTER TABLE "+TABLE_NAME+" DROP PRIMARY KEY");
        //db.execSQL("ALTER TABLE "+TABLE_NAME+" DROP "+KEY_ID);
        //db.execSQL("ALTER TABLE "+TABLE_NAME+" ADD "+KEY_ID+" INTEGER AUTO_INCREMENT PRIMARY KEY");

        String countQuery = "SELECT  * FROM " + TABLE_NAME;
        Cursor cursor = db.rawQuery(countQuery, null);
        cursor.moveToPosition(id);

        r.setClr_text(cursor.getString(cursor.getColumnIndex(KEY_CLR)));
        r.setCfr_text(cursor.getString(cursor.getColumnIndex(KEY_CFR)));
        r.setOrdineR(cursor.getString(cursor.getColumnIndex(KEY_ORD)));
        r.setPosR(cursor.getString(cursor.getColumnIndex(KEY_POS)));
        r.setSwitcher(cursor.getString(cursor.getColumnIndex(KEY_SWI)));
        r.setReflector(cursor.getString(cursor.getColumnIndex(KEY_REF)));



        cursor.close();
        db.close();



        return r;
    }

    public List getAllRecords() {

        // 1. build the query
        String query = "SELECT  * FROM " + TABLE_NAME;

        // 2. get reference to writable DB
        SQLiteDatabase db = this.getWritableDatabase();
        Cursor cursor = db.rawQuery(query, null);

        List<Record> list = new LinkedList<Record>();

        int count=0;

        if (cursor.moveToFirst()) {
            do {
                list.add(count,new Record(cursor.getInt(cursor.getColumnIndex(KEY_ID)),cursor.getString(cursor.getColumnIndex(KEY_CLR)),cursor.getString(cursor.getColumnIndex(KEY_CFR)),
                        cursor.getString(cursor.getColumnIndex(KEY_ORD)),cursor.getString(cursor.getColumnIndex(KEY_POS)),cursor.getString(cursor.getColumnIndex(KEY_SWI)),
                        cursor.getString(cursor.getColumnIndex(KEY_REF))));
                count++;
            } while (cursor.moveToNext());
        }

        // return books
        db.close();
        return list;
    }

    public void deleteTable() {

        SQLiteDatabase db = this.getWritableDatabase();

        // Drop older records table if existed
        db.execSQL("DROP TABLE IF EXISTS "+TABLE_NAME);

        // create fresh records table
        this.onCreate(db);

        db.close();
    }

    public void deleteItem(int id){

        SQLiteDatabase db = this.getWritableDatabase();
        //db.execSQL("DELETE FROM "+TABLE_NAME+" WHERE "+KEY_ID+" = "+id);
        //db.execSQL("ALTER TABLE "+TABLE_NAME+" DROP PRIMARY KEY");
        //db.execSQL("ALTER TABLE "+TABLE_NAME+" DROP "+KEY_ID);
        //db.execSQL("ALTER TABLE "+TABLE_NAME+" ADD "+KEY_ID+" INTEGER AUTO_INCREMENT PRIMARY KEY");

        String countQuery = "SELECT  * FROM " + TABLE_NAME;
        Cursor cursor = db.rawQuery(countQuery, null);
        cursor.moveToPosition(id);
        int cnt = cursor.getCount();

        for(int j=id+1;j<=cnt;j++,cursor.moveToNext()) {

            String n=cursor.getString(1);
            Log.i("N",""+n);
            String p=cursor.getString(2);
            Log.i("P",""+p);
            int index = j-1;
            db.execSQL("UPDATE " + TABLE_NAME + " SET " + KEY_CLR +" = '"+n+"', "+KEY_CFR+" = '"+p+"' WHERE " + KEY_ID + " = "+index);
        }

        db.execSQL("DELETE FROM "+TABLE_NAME+" WHERE "+KEY_ID+" = "+cnt);
        cursor.close();
        db.close();

    }




}
