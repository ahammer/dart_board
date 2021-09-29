package io.dartboard.add2appe

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.Button
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import io.dartboard.add2appe.ui.theme.Add2AppTheme
import io.flutter.embedding.android.FlutterActivity


/// The entry point into this Add2app Example
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Add2AppTheme {
                // A surface container using the 'background' color from the theme
                Surface(color = MaterialTheme.colors.background) {
                    NavigationButtons()
                }
            }
        }
    }
}


@Composable
fun NavigationButtons() {
    var context = LocalContext.current;

    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Button(
            modifier = Modifier.padding(4.dp),
            onClick = {
                showFlutterActivity(context)
            }) {
            Text("Go to Example")
        }
        Button(
            modifier = Modifier.padding(4.dp),
            onClick = {}) {
            Text(text = "Go to SpaceX Launches")
        }
        Button(
            modifier = Modifier.padding(4.dp),
            onClick = {}) {
            Text(text = "Go to Minesweeper")
        }
    }

}

fun showFlutterActivity(context: Context) {
    context.startActivity(Intent(context, FlutterActivity::class.java))
}


@Preview(showBackground = true)
@Composable
fun DefaultPreview() {
    Add2AppTheme {
        NavigationButtons()
    }
}

