package com.example.nik.myapplication;

/**
 * Created by Nik on 02/06/2015.
 */
public class Reflector {


    //private:

    char name;
    char[] R = new char[26];
    char[] L = new char[26]; //Scambi effettuati dal riflettore

    //public:

    void setName(char n)
    {
        name=n;
    }

    char getName()
    {
        return name;
    }

    void init()
    {
        for(int i=0;i<26;i++)
        {
            R[i]= (char) (65+i);
        }
        switch(name){
            case('B'):
            {
                String arr_L = "YRUHQSLDPXNGOKMIEBFZCWVJAT";
                for(int i=0;i<26;i++)
                    L[i]=arr_L.charAt(i);
            }
            break;
            case('C'):
            {
                String arr_L = "FVPJIAOYEDRZXWGCTKUQSBNMHL";
                for(int i=0;i<26;i++)
                    L[i]=arr_L.charAt(i);
            }
            break;

            default:
                for(int i=0;i<26;i++)
                    L[i]='0';
                break;
        }
    }
/*
    void print()
    {
        cout<<"L R"<<endl<<endl;
        for(int i=0;i<26;i++)
        {
            cout<<L[i]<<" "<<R[i]<<endl;
        }

    }
*/
    int contact(char x,Boolean flag)
    {
        int index=0;

        if(!flag)
        {
            for(int i=0;i<26;i++)
            {
                if(L[i]==x)
                    index=i;
            }
        }
        else if(flag)
        {
            for(int i=0;i<26;i++)
            {
                if(R[i]==x)
                    index=i;
            }
        }


        return index;
    }

    char getLetter(int index, char side)
    {
        char x='0';
        if(side=='R')
            x = R[index];
        if(side=='L')
            x = L[index];

        return x;
    }

}
