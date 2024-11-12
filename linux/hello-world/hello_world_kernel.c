#include <linux/init.h>
#include <linux/module.h>

MODULE_AUTHOR("Joshua Culwell");
MODULE_DESCRIPTION("Hello world");
MODULE_LICENSE("Dual MIT/GPL");

static int __init init_function(void){
	printk("Hello, world");
	return 0;
}

static void __exit exit_function(void){
	printk("Goodbye, cruel world");
}

module_init(init_function);
module_exit(exit_function);
