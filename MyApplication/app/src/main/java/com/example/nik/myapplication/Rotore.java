package com.example.nik.myapplication;

/**
 * Created by Nik on 02/06/2015.
 */
public class Rotore {

        //private :

            private char name;
            private char[] R = new char[26];
            private char[] L = new char[26]; //Contatti presenti su entrambe le facce del rotore
            private int sfasamento;
            private char pos_ini;


        //public:

        /*
        Rotore(char n, int a, char b){
            sfasamento=a;
            pos_ini=b;
            init(R);
            sfasa(L,sfasamento);
            name=n;
        }

        Rotore(char n){
            name=n;
        }
        */

        public void setSfasamento(int s)
        {
            sfasamento=s;
        }

        public void setName(char n)
        {
            name=n;
        }

        public void setPos_ini(int p)
        {
            pos_ini= (char) p;
        }

        public char getName()
        {
            return name;
        }

        public void init()
        {
            for(int i=0;i<26;i++)
            {
                R[i]= (char) (65+i);
                L[i]= (char) (65+i);
            }
            switch(name){
                case('1'):
                {
                    String arr_L = "EKMFLGDQVZNTOWYHXUSPAIBRCJ";
                    for(int i=0;i<26;i++)
                        L[i]=arr_L.charAt(i);
                }
                break;
                case('2'):
                {
                    String arr_L = "AJDKSIRUXBLHWTMCQGZNPYFVOE";
                    for(int i=0;i<26;i++)
                        L[i]=arr_L.charAt(i);
                }
                break;
                case('3'):
                {
                    String arr_L = "BDFHJLCPRTXVZNYEIWGAKMUSQO";
                    for(int i=0;i<26;i++)
                        L[i]=arr_L.charAt(i);
                }
                break;
                case('4'):
                {
                    String arr_L = "ESOVPZJAYQUIRHXLNFTGKDCMWB";
                    for(int i=0;i<26;i++)
                        L[i]=arr_L.charAt(i);
                }
                break;
                case('5'):
                {
                    String arr_L = "VZBRGITYUPSDNHLXAWMJQOFECK";
                    for(int i=0;i<26;i++)
                        L[i]=arr_L.charAt(i);
                }
                break;

                default:
                    for(int i=0;i<26;i++)
                        R[i]='0';
                    break;
            }
        }
        /*
                void sfasa()//RIGUARDARE E UTLIZZARE FUNZIONE DI SCAMBIO DOPO AVER INIZIALIZZATO L
                {
                    int sf_copy;
                    sf_copy=sfasamento;
                    for(int i=0;i<26;i++)
                    {
                        L[i]=(sf_copy%26)+65;
                        sf_copy++;
                    }
                }
        */
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
        public void scatta()//OTTIMIZZARE, SENZA ARGOMENTI TANTO SCATTANO SEMPRE ENTRAMBI
        {
            char temp0='0';
            for(int i=0;i<26;i++)
            {
                if(i==0)
                {
                    temp0=R[i];
                    R[i]=R[i+1];
                }
                else if(i!=25)
                    R[i]=R[i+1];

                if(i==25)
                    R[i]=temp0;
            }

            for(int i=0;i<26;i++)
            {
                if(i==0)
                {
                    temp0=L[i];
                    L[i]=L[i+1];
                }
                else if(i!=25)
                    L[i]=L[i+1];

                if(i==25)
                    L[i]=temp0;
            }
        }


        public int contact(char x,Boolean flag)
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

        public char getLetter(int index, char side)
        {
            char x='0';
            if(side=='R')
                x = R[index];
            if(side=='L')
                x = L[index];

            return x;
        }





}
