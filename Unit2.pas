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
//  HookAddress: dword = $006116FA;   //ͨ���������ݱ仯 ����ce�ҵ���һ����ַ

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
  MessageBox(0, 'mygod', '�ҵ��Ǹ���', 0);
end;

procedure new_addrA();
begin
  asm
        add     esp , 4;
        add     esp , 4;

        add     esp , 4;
        add     esp , 4;

//        add esp,$10

        //ƽ��� ��һ������ 4��push
//        ///////////////////////////////////
        pushad
        pushf
        xor eax,eax;     //�����ݴ��ݳ�ȥ
        mov eax,$20;
        push eax
        push eax
        call    show_item_data

//        �Լ�ƽ���ջ
        add     esp, 4     //ƽ�����1��
        
        pop eax;         //ƽ�����2��


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
        pop edx        //���� bbb    ��ջ ����edx ����ʹ��


        
        add     esp, 4;  //ƽ�����һ��ջ     MessageBox ѹ���� 4������

 //------------------------------------------------------------------------------------
        
        push    0
        push    ecx
        push    edx
        push    0
        CALL    MessageBoxW      //˭����˭ƽ�� ϵͳ�����Ѿ���������ƽ��   �����ֶ�ƽ��
              
        
//        ----------------------------------------------------------------------
        pushad
        pushf
        XOR     eax, eax;     //�����ݴ��ݳ�ȥ
        mov     eax, $20;
        push    eax
        push    eax
        call    show_item_data  //�Զ��庯��
        
//        ��ʼƽ���ջ    ˭����˭ƽ�� �Զ��庯����Ҫ�Լ�ƽ���ջ
        pop     eax;          //ƽ��1
        add     esp, 4         //ƽ��2
        
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

//        mov     eax, $006116F0 //������ַ
//        call    eax;
end.

