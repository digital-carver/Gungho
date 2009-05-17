use Test::More;

if (-d '.git' || $ENV{TEST_AUTHOR}) {
    eval {
        require Test::CleanNamespaces;
        Test::CleanNamespaces->import('all_namespaces_clean');
    };
    if($@) {
        plan skip_all => "Test requires Test::CleanNamespaces";
    } else {
        all_namespaces_clean();
    }
}
