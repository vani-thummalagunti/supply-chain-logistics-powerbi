/*
    =================================================================================
    SUPPLY CHAIN & LOGISTICS SLA POWER QUERY (M) SCRIPT
    =================================================================================
*/
let
    Source = Csv.Document(File.Contents("C:\data\shipments_raw.csv"), [Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{
        {"ShipmentID", type text}, {"ShipDate", type date}, {"Carrier", type text}, 
        {"ShippingMode", type text}, {"OriginWarehouse", type text}, {"DestinationType", type text}, 
        {"PromisedDays", Int64.Type}, {"ActualDays", Int64.Type}, {"DelayDays", Int64.Type}, 
        {"IsDelayed", type text}, {"DelayReason", type text}, {"ShippingCost", type number}
    }),
    // Standardize IsDelayed casing ('yes' -> 'Yes', 'no' -> 'No')
    #"Cleaned Delayed Text" = Table.TransformColumns(#"Changed Type", {{"IsDelayed", Text.Proper, type text}}),
    // Impute missing ShippingCost
    #"Replaced Null Cost" = Table.ReplaceValue(#"Cleaned Delayed Text", null, 65.0, Replacer.ReplaceValue, {"ShippingCost"})
in
    #"Replaced Null Cost"
