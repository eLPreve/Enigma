package com.example.nik.myapplication;

/**
 * Created by Nik on 02/06/2015.
 */
public class Plugboard {


    //private:

    char[] D = new char[26];
    char[] S = new char[26];

    //public:

    void init()
    {
        for(int i=0;i<26;i++)
        {
            D[i]= (char) (65+i);
            S[i]= (char) (65+i);
        }
    }

    void config(String a)
    {
        for(int i=0;i<26;i++)
        {
            if(D[i]==a.charAt(0))
                S[i]=a.charAt(1);
            if(D[i]==a.charAt(1))
                S[i]=a.charAt(0);
        }
    }

    char scambia(char a)
    {
        char x='0';
        for(int i=0;i<26;i++)
        {
            if(a==D[i])
                x=S[i];
        }
        return x;
    }
    /*
    void print()
    {
        cout<<"R L"<<endl<<endl;
        for(int i=0;i<26;i++)
        {
            cout<<D[i]<<" "<<S[i]<<endl;
        }

    }
    */

}
