with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Randompackage; use Randompackage;

procedure main is
   procedure wyswietl (i,l : in Integer) is
   begin
      Put("Zadanie ");
      Put(l,2);
      Put(" po raz ");
      Put(i,2);
   end wyswietl;

   task Serwer is
      entry Zajmij;
      entry Zwolnij;
   end Serwer;

   task body Serwer is
   begin
      loop
         accept Zajmij;
         accept Zwolnij;
      end loop;
   end Serwer;

   task type wyswietlanko(nr_zadania : Integer);

   task body wyswietlanko is
      N : Integer;
      i : Integer;
      kolumna : Integer;
      delayTime : Integer;
   begin
      N := 10;
      i := 1;
      kolumna := (nr_zadania-1)*22 +1;
      for i in 1..N loop
         -- sekcja lokalna BEG
         delayTime := RandomInt(3);
         Delay(Standard.Duration(delayTime));
         -- sekcja lokalna END

         Serwer.Zajmij;
         -- sekcja krytyczna BEG
         Set_Col(Positive_Count(kolumna));
         wyswietl(i,nr_zadania);
         -- sekcja krytyczna END
         Serwer.Zwolnij;
      end loop;

   end wyswietlanko;

   zadanko1 : wyswietlanko(1);
   zadanko2 : wyswietlanko(2);
   --zadanko3 : wyswietlanko(3);
   --zadanko4 : wyswietlanko(4);

begin
   null;
end main;
