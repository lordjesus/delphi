unit BoxPrimitive;

interface

uses
  Classes;

type

TRSBoxPrimitive<T> = class(TObject)
{ Purpose: To provide a simple class for boxing and unboxing a primitive type
Note: this class is only for use by AUTOREFCOUNT compilers }
private
  { private declarations }
  FValue: T;
protected
  { protected declarations }
public
  { public declarations }
  constructor Create( const V: T );
  class operator Equal(a,b: TRSBoxPrimitive<T>): Boolean;
  class operator NotEqual(a,b: TRSBoxPrimitive<T>): Boolean;
  class function IndexOf( const Strings: TStrings; a: T ): Integer;
  class operator Implicit(a: T): TRSBoxPrimitive<T>;
  class operator Implicit(a: TRSBoxPrimitive<T>): T;
  class operator Explicit(a: T): TRSBoxPrimitive<T>;
  class operator Explicit(a: TRSBoxPrimitive<T>): T;
end; { TRSBoxPrimitive<T> }

implementation

class operator TRSBoxPrimitive<T>.Explicit(a: T): TRSBoxPrimitive<T>;
begin
  result := TRSBoxPrimitive<T>.Create(a);
end;

class operator TRSBoxPrimitive<T>.Equal(a,b: TRSBoxPrimitive<T>): Boolean;
begin
  result := a.FValue = b.FValue;
end;

class operator TRSBoxPrimitive<T>.Implicit(a: TRSBoxPrimitive<T>): T;
begin
  result := a.FValue;
end;

end.
