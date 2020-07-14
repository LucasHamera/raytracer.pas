unit Utils_Types;

interface

type
  TOptional<T> = record
  strict private
    fValue: T;
    fHasValue: Boolean;

  public
    constructor Create(const lValue: T);

    property Value: T read fValue;
    property HasValue: Boolean read fHasValue;

    class operator Explicit(const lValue: T): TOptional<T>;
    class operator Implicit(const lOptional: TOptional<T>): Boolean;
  end;

implementation

{ TOptional<T> }

constructor TOptional<T>.Create(const lValue: T);
begin
  fValue := lValue;
  fHasValue := True;
end;

class operator TOptional<T>.Explicit(const lValue: T): TOptional<T>;
begin
  Result := TOptional<T>.Create(lValue);
end;

class operator TOptional<T>.Implicit(const lOptional: TOptional<T>): Boolean;
begin
  Result := lOptional.HasValue;
end;

end.
