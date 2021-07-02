unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tlhelp32,
  PsAPI, Vcl.StdCtrls, Vcl.ExtCtrls, u_debug, DDetours, Method2;

type
  TForm2 = class(TForm)
    Button4: TButton;
    Button5: TButton;
    ListBox1: TListBox;
    Button3: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  Form2: TForm2;
//  HookAddress: dword = $006116FA;   //通过查找数据变化 利用ce找到的一个地址

  HookAddress: dword = $0060F72A;
  HookAddressSave: array[0..4] of Byte;
  JumpBackAddress: dword;

implementation

{$R *.dfm}
uses
  Method1, Method3;

procedure show_item_data(v, v2: Integer);
begin
  form2.ListBox1.Items.Insert(0, v.ToString + '  ' + v2.ToHexString);
  MessageBox(0, 'mygod', '我的那个天', 0);
end;

procedure new_addrA();
begin
  asm
        add     esp , 4;
        add     esp , 4;

        add     esp , 4;
        add     esp , 4;

//        add esp,$10

        //平衡掉 上一个函数 4个push
//        ///////////////////////////////////
        pushad
        pushf
        xor eax,eax;     //把数据传递出去
        mov eax,$20;
        push eax
        push eax
        call    show_item_data

//        自己平衡堆栈
        add     esp, 4     //平衡掉第1个
        
        pop eax;         //平衡掉第2个


        popf
        popad
        jmp     JumpBackAddress
  end;

end;



procedure new_addrB();
begin
  asm
        add     esp, 4;

        
        XOR     ecx, ecx
        pop     ecx      //MessageBox(0,'aaa','bbb',0);      aaa

        sub edx,edx    //
        pop edx        //数据 bbb    出栈 放入edx 后面使用


        
        add     esp, 4;  //平衡最后一个栈     MessageBox 压入了 4个参数

 //------------------------------------------------------------------------------------
        
        push    0
        push    ecx
        push    edx
        push    0
        CALL    MessageBoxW      //谁调用谁平衡 系统函数已经帮你做了平衡   不用手动平衡
              
        
//        ----------------------------------------------------------------------
        pushad
        pushf
        XOR     eax, eax;     //把数据传递出去
        mov     eax, $20;
        push    eax
        push    eax
        call    show_item_data  //自定义函数
        
//        开始平衡堆栈    谁调用谁平衡 自定义函数需要自己平衡堆栈
        pop     eax;          //平衡1
        add     esp, 4         //平衡2
        
        popf
        popad
        jmp     JumpBackAddress
  end;
end;



procedure TForm2.Button4Click(Sender: TObject);
begin
 f1(@new_addrA, pointer(HookAddress));
end;

procedure TForm2.Button7Click(Sender: TObject);
begin
  f2(@new_addrB, Pointer(HookAddress));
end;





procedure TForm2.FormCreate(Sender: TObject);
begin
//  JumpBackAddress := $006116FA + 5;
  JumpBackAddress := HookAddress + SizeOf(TInstruction);

  CopyMemory(@HookAddressSave, Pointer(HookAddress), 5);  //memcpy

end;

//        mov     eax, $006116F0 //函数地址
//        call    eax;
end.

