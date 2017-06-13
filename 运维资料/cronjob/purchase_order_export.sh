

mysql_host="localhost"
mysql_user="root"
mysql_passwd="mysql_passwd"
DB_name="xxx_com"
XLS_name="/home/wwwlogs/orderexport/purchase_order.csv"
XLS_name_to="/home/wwwlogs/orderexport/purchase_order`date -u +"%Y%m%d%H"`.csv"

/usr/bin/mysql -u${mysql_user} -h${mysql_host} -p${mysql_passwd} -e "use xxx_com;
SELECT
sales_flat_order.created_at as orderDate,
sales_flat_order.increment_id as orderId,
sales_flat_order_item.sku as SKU,
sales_flat_order_item.name as pName,
at_description.value as pDesc,
at_product_code.value as pSupplierSKU,
at_supplier_code.value as psupplierCode,
SUM(sales_flat_order_item.qty_ordered) as qty,
sales_flat_order_item.price*6.15/2 as price,
SUM(sales_flat_order_item.row_total)*6.15/2 as totalPrice
FROM sales_flat_order
INNER JOIN sales_flat_order_address ON sales_flat_order_address.parent_id = sales_flat_order.entity_id
INNER JOIN sales_flat_order_item ON sales_flat_order_item.order_id = sales_flat_order.entity_id
INNER JOIN catalog_product_entity_varchar AS at_product_code ON (at_product_code.entity_id = sales_flat_order_item.product_id) AND (at_product_code.attribute_id = '184') AND (at_product_code.store_id = 0) 
INNER JOIN catalog_product_entity_text AS at_description ON (at_description.entity_id = sales_flat_order_item.product_id) AND (at_description.attribute_id = '72') AND (at_description.store_id = 0) 
INNER JOIN catalog_product_entity_varchar AS at_supplier_code ON (at_supplier_code.entity_id = sales_flat_order_item.product_id) AND (at_supplier_code.attribute_id = '194') AND (at_supplier_code.store_id = 0) 
where (sales_flat_order.status = 'processing' or sales_flat_order.status = 'payment_review')
AND sales_flat_order.created_at <= NOW()
AND sales_flat_order.created_at > date_sub(now(), interval 19 hour)
and sales_flat_order_address.address_type='shipping'
GROUP BY sales_flat_order_item.sku;
"

if [ ` ls -l ${XLS_name} | awk '{print $5}' ` != 0 ]; 
then mv ${XLS_name} ${XLS_name_to};
mutt -s "xxx: Purchase Order"  gogo@xxx.com young@xxx.com jack@xxx.com < ${XLS_name_to}  -a ${XLS_name_to};
else rm ${XLS_name};
fi
