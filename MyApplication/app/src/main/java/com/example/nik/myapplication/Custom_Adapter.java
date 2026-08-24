package com.example.nik.myapplication;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.example.nik.myapplication.database.Record;

import java.util.List;

/**
 * Created by Preve on 15/07/2014.
 */
public class Custom_Adapter extends ArrayAdapter<Record> {

    public Custom_Adapter(Context context, int textViewResourceId, List objects) {
        super(context, textViewResourceId, objects);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        convertView = inflater.inflate(R.layout.rowdb, null);
        TextView id = (TextView)convertView.findViewById(R.id.id);
        TextView clr = (TextView)convertView.findViewById(R.id.clr_text);
        TextView cfr = (TextView)convertView.findViewById(R.id.cfr_text);
        Record r = getItem(position);
        clr.setText(r.getClr_text());
        id.setText(r.getId());
        cfr.setText(r.getCfr_text());
        return convertView;
    }

}